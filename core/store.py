"""数据存储：site.json（个人资料 / 项目 / 奖项）+ 项目代码文件。

设计要点：
- 所有写操作加锁，避免并发请求把 JSON 写坏；
- 文件路径做穿越防护，只允许写到 data/projects/<项目id>/ 下；
- 文件列表维护在 site.json 里，删文件时同步更新。
"""
from __future__ import annotations

import copy
import json
import os
import re
import shutil
import threading
import uuid
from pathlib import Path

from .config import MAX_UPLOAD


def _safe_relpath(name: str) -> str:
    """把上传的相对路径清洗成安全的相对路径（保留目录结构，阻止穿越）。"""
    raw = str(name).replace("\\", "/")
    parts: list[str] = []
    for seg in raw.split("/"):
        if not seg or seg in (".", ".."):
            continue
        seg = re.sub(r"[^\w.\-()\[\] ]+", "_", seg).strip().lstrip(".")
        if seg:
            parts.append(seg)
    return "/".join(parts) or "file"


def _safe_id(project_id: str) -> str:
    return re.sub(r"[^A-Za-z0-9_\-]+", "", str(project_id))


def _new_id(prefix: str = "") -> str:
    return (prefix + uuid.uuid4().hex[:8]) if prefix else uuid.uuid4().hex[:8]


class SiteStore:
    def __init__(self, data_dir: Path, projects_dir: Path):
        self.data_dir = Path(data_dir)
        self.projects_dir = Path(projects_dir)
        self.site_file = self.data_dir / "site.json"
        self.lock = threading.RLock()
        self.data = self._load()

    # ---- 基础读写 ----
    def _load(self) -> dict:
        if self.site_file.exists():
            try:
                return json.loads(self.site_file.read_text(encoding="utf-8"))
            except (json.JSONDecodeError, OSError):
                pass
        return {"profile": {}, "projects": [], "awards": []}

    def _save(self) -> None:
        self.data_dir.mkdir(parents=True, exist_ok=True)
        self.site_file.write_text(
            json.dumps(self.data, ensure_ascii=False, indent=2), encoding="utf-8")

    def get_site(self) -> dict:
        with self.lock:
            return copy.deepcopy(self.data)

    # ---- 个人资料 ----
    def update_profile(self, profile: dict) -> dict:
        with self.lock:
            self.data["profile"] = profile
            self._save()
            return copy.deepcopy(self.data["profile"])

    # ---- 奖项 ----
    def add_award(self, award: dict) -> dict:
        with self.lock:
            award = dict(award)
            award["id"] = award.get("id") or _new_id("a_")
            self.data.setdefault("awards", []).append(award)
            self._save()
            return award

    def update_award(self, award_id: str, award: dict) -> dict | None:
        with self.lock:
            for i, item in enumerate(self.data.get("awards", [])):
                if item.get("id") == award_id:
                    award = dict(award)
                    award["id"] = award_id
                    self.data["awards"][i] = award
                    self._save()
                    return award
            return None

    def delete_award(self, award_id: str) -> bool:
        with self.lock:
            awards = self.data.get("awards", [])
            remaining = [a for a in awards if a.get("id") != award_id]
            if len(remaining) == len(awards):
                return False
            self.data["awards"] = remaining
            self._save()
            return True

    # ---- 项目 ----
    def add_project(self, project: dict) -> dict:
        with self.lock:
            project = dict(project)
            project["id"] = project.get("id") or _new_id("p_")
            project.setdefault("files", [])
            self.data.setdefault("projects", []).append(project)
            self._save()
            return project

    def update_project(self, project_id: str, project: dict) -> dict | None:
        with self.lock:
            for i, item in enumerate(self.data.get("projects", [])):
                if item.get("id") == project_id:
                    project = dict(project)
                    project["id"] = project_id
                    project.setdefault("files", item.get("files", []))
                    project.setdefault("screenshots", item.get("screenshots", []))
                    self.data["projects"][i] = project
                    self._save()
                    return project
            return None

    def delete_project(self, project_id: str) -> bool:
        with self.lock:
            projects = self.data.get("projects", [])
            remaining = [p for p in projects if p.get("id") != project_id]
            if len(remaining) == len(projects):
                return False
            self.data["projects"] = remaining
            shutil.rmtree(self.projects_dir / project_id, ignore_errors=True)
            self._save()
            return True

    # ---- 项目文件 ----
    def _project(self, project_id: str) -> dict | None:
        for p in self.data.get("projects", []):
            if p.get("id") == project_id:
                return p
        return None

    def add_file(self, project_id: str, name: str, content: bytes) -> dict | None:
        if len(content) > MAX_UPLOAD:
            raise ValueError("文件超过 8MB 限制")
        pid = _safe_id(project_id)
        safe = _safe_relpath(name)
        with self.lock:
            project = self._project(pid)
            if project is None:
                return None
            folder = self.projects_dir / pid
            target = folder / safe
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(content)
            files = [f for f in project.get("files", []) if f["name"] != safe]
            files.append({"name": safe, "size": len(content)})
            project["files"] = files
            self._save()
            return {"name": safe, "size": len(content)}

    def delete_file(self, project_id: str, name: str) -> bool:
        pid = _safe_id(project_id)
        safe = _safe_relpath(name)
        with self.lock:
            project = self._project(pid)
            if project is None:
                return False
            path = self.projects_dir / pid / safe
            if path.exists():
                path.unlink()
            project["files"] = [f for f in project.get("files", []) if f["name"] != safe]
            self._save()
            return True

    def file_path(self, project_id: str, name: str) -> Path | None:
        pid = _safe_id(project_id)
        safe = _safe_relpath(name)
        base = (self.projects_dir / pid).resolve()
        path = (base / safe).resolve()
        if base != path and not str(path).startswith(str(base) + os.sep):
            return None
        return path if path.exists() and path.is_file() else None

    # ---- 运行截图 ----
    def _shots_dir(self, pid: str) -> Path:
        return self.projects_dir / pid / "_screenshots"

    def add_screenshot(self, project_id: str, name: str, content: bytes) -> dict | None:
        if len(content) > MAX_UPLOAD:
            raise ValueError("文件超过 8MB 限制")
        pid = _safe_id(project_id)
        safe = _safe_relpath(name).split("/")[-1]
        with self.lock:
            project = self._project(pid)
            if project is None:
                return None
            folder = self._shots_dir(pid)
            folder.mkdir(parents=True, exist_ok=True)
            (folder / safe).write_bytes(content)
            shots = [s for s in project.get("screenshots", []) if s["name"] != safe]
            shots.append({"name": safe, "size": len(content)})
            project["screenshots"] = shots
            self._save()
            return {"name": safe, "size": len(content)}

    def delete_screenshot(self, project_id: str, name: str) -> bool:
        pid = _safe_id(project_id)
        safe = _safe_relpath(name).split("/")[-1]
        with self.lock:
            project = self._project(pid)
            if project is None:
                return False
            path = self._shots_dir(pid) / safe
            if path.exists():
                path.unlink()
            project["screenshots"] = [
                s for s in project.get("screenshots", []) if s["name"] != safe]
            self._save()
            return True

    def screenshot_path(self, project_id: str, name: str) -> Path | None:
        pid = _safe_id(project_id)
        safe = _safe_relpath(name).split("/")[-1]
        base = self._shots_dir(pid).resolve()
        path = (base / safe).resolve()
        if not str(path).startswith(str(base) + os.sep):
            return None
        return path if path.exists() and path.is_file() else None
