"""个人博客 · Web 服务（Python 标准库，零重型依赖）。

启动：python app.py
- 作品集页面：http://127.0.0.1:8003
- 管理后台：  http://127.0.0.1:8003/admin

接口：
  GET    /api/site
  PUT    /api/profile
  POST   /api/awards             PUT/DELETE /api/awards/<id>
  POST   /api/projects           PUT/DELETE /api/projects/<id>
  POST   /api/projects/<id>/files          上传（base64）
  DELETE /api/projects/<id>/files/<name>
  GET    /api/projects/<id>/files/<name>   下载 / ?preview=1 在线预览
"""
from __future__ import annotations

import base64
import json
import mimetypes
import re
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse

from core.config import DATA_DIR, HOST, PORT, PROJECTS_DIR, STATIC_DIR, TEXT_EXTS
from core.store import SiteStore

STORE = SiteStore(DATA_DIR, PROJECTS_DIR)

RE_AWARD = re.compile(r"^/api/awards/([^/]+)$")
RE_PROJECT = re.compile(r"^/api/projects/([^/]+)$")
RE_FILE = re.compile(r"^/api/projects/([^/]+)/files/(.+)$")
RE_UPLOAD = re.compile(r"^/api/projects/([^/]+)/files$")
RE_SHOT = re.compile(r"^/api/projects/([^/]+)/screenshots$")
RE_SHOT_FILE = re.compile(r"^/api/projects/([^/]+)/screenshots/([^/]+)$")


class Handler(BaseHTTPRequestHandler):
    # ---- 基础响应 ----
    def _send(self, code: int, body: bytes, content_type: str = "application/json",
              extra: dict | None = None) -> None:
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def _json(self, code: int, payload: dict) -> None:
        self._send(code, json.dumps(payload, ensure_ascii=False).encode("utf-8"),
                   "application/json; charset=utf-8")

    def _body(self) -> dict:
        length = int(self.headers.get("Content-Length", 0))
        raw = self.rfile.read(length) if length else b"{}"
        return json.loads(raw or b"{}")

    def _page(self, filename: str) -> None:
        path = STATIC_DIR / filename
        if not path.exists():
            self._json(404, {"error": "页面不存在"})
            return
        self._send(200, path.read_bytes(), "text/html; charset=utf-8")

    # ---- GET ----
    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        path = unquote(parsed.path)
        if path in ("/", "/index.html"):
            self._page("index.html")
            return
        if path == "/admin":
            self._page("admin.html")
            return
        if path == "/demo":
            self._page("demo.html")
            return
        if path == "/api/site":
            self._json(200, STORE.get_site())
            return

        m = RE_FILE.match(path)
        if m:
            project_id, name = m.group(1), m.group(2)
            file_path = STORE.file_path(project_id, name)
            if file_path is None:
                self._json(404, {"error": "文件不存在"})
                return
            preview = (parse_qs(parsed.query).get("preview") or [""])[0] == "1"
            if preview:
                if file_path.suffix.lower() not in TEXT_EXTS:
                    self._json(400, {"error": "该文件类型不支持在线预览"})
                    return
                if file_path.stat().st_size > 300_000:
                    self._json(400, {"error": "文件过大，请下载查看"})
                    return
                text = file_path.read_text(encoding="utf-8", errors="replace")
                self._send(200, text.encode("utf-8"), "text/plain; charset=utf-8")
                return
            mime, _ = mimetypes.guess_type(file_path.name)
            disposition = f'attachment; filename="{file_path.name}"'
            self._send(200, file_path.read_bytes(), mime or "application/octet-stream",
                       {"Content-Disposition": disposition})
            return

        m = RE_SHOT_FILE.match(path)
        if m:
            project_id, name = m.group(1), m.group(2)
            shot = STORE.screenshot_path(project_id, name)
            if shot is None:
                self._json(404, {"error": "截图不存在"})
                return
            mime, _ = mimetypes.guess_type(shot.name)
            self._send(200, shot.read_bytes(), mime or "image/png")
            return

        self._json(404, {"error": "not found"})

    # ---- POST ----
    def do_POST(self) -> None:
        try:
            path = urlparse(self.path).path
            if path == "/api/awards":
                award = STORE.add_award(self._body())
                self._json(200, {"award": award})
            elif path == "/api/projects":
                project = STORE.add_project(self._body())
                self._json(200, {"project": project})
            elif RE_UPLOAD.match(path):
                project_id = RE_UPLOAD.match(path).group(1)
                data = self._body()
                name = data.get("name", "")
                content_b64 = data.get("content", "")
                if not name or not content_b64:
                    self._json(400, {"error": "文件名和内容不能为空"})
                    return
                raw = base64.b64decode(content_b64)
                info = STORE.add_file(project_id, name, raw)
                if info is None:
                    self._json(404, {"error": "项目不存在"})
                else:
                    self._json(200, {"file": info})
            elif RE_SHOT.match(path):
                project_id = RE_SHOT.match(path).group(1)
                data = self._body()
                name = data.get("name", "")
                content_b64 = data.get("content", "")
                if not name or not content_b64:
                    self._json(400, {"error": "文件名和内容不能为空"})
                    return
                raw = base64.b64decode(content_b64)
                info = STORE.add_screenshot(project_id, name, raw)
                if info is None:
                    self._json(404, {"error": "项目不存在"})
                else:
                    self._json(200, {"screenshot": info})
            else:
                self._json(404, {"error": "not found"})
        except Exception as exc:
            self._json(500, {"error": str(exc)})

    # ---- PUT ----
    def do_PUT(self) -> None:
        try:
            path = urlparse(self.path).path
            if path == "/api/profile":
                self._json(200, {"profile": STORE.update_profile(self._body())})
                return
            m = RE_AWARD.match(path)
            if m:
                award = STORE.update_award(m.group(1), self._body())
                self._json(200 if award else 404, {"award": award} if award else {"error": "奖项不存在"})
                return
            m = RE_PROJECT.match(path)
            if m:
                project = STORE.update_project(m.group(1), self._body())
                self._json(200 if project else 404,
                           {"project": project} if project else {"error": "项目不存在"})
                return
            self._json(404, {"error": "not found"})
        except Exception as exc:
            self._json(500, {"error": str(exc)})

    # ---- DELETE ----
    def do_DELETE(self) -> None:
        try:
            path = unquote(urlparse(self.path).path)
            m = RE_AWARD.match(path)
            if m:
                self._json(200, {"ok": STORE.delete_award(m.group(1))})
                return
            m = RE_PROJECT.match(path)
            if m:
                self._json(200, {"ok": STORE.delete_project(m.group(1))})
                return
            m = RE_FILE.match(path)
            if m:
                self._json(200, {"ok": STORE.delete_file(m.group(1), m.group(2))})
                return
            m = RE_SHOT_FILE.match(path)
            if m:
                self._json(200, {"ok": STORE.delete_screenshot(m.group(1), m.group(2))})
                return
            self._json(404, {"error": "not found"})
        except Exception as exc:
            self._json(500, {"error": str(exc)})

    def log_message(self, *args) -> None:
        pass


def main() -> None:
    print("=" * 60)
    print("  🌐 个人博客已启动")
    print(f"  作品集：http://127.0.0.1:{PORT}")
    print(f"  管理后台：http://127.0.0.1:{PORT}/admin")
    print("=" * 60)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()


if __name__ == "__main__":
    main()
