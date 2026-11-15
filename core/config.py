"""个人博客配置。"""
from __future__ import annotations

from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
SITE_FILE = DATA_DIR / "site.json"
PROJECTS_DIR = DATA_DIR / "projects"
STATIC_DIR = BASE_DIR / "static"

HOST, PORT = "127.0.0.1", 8003
MAX_UPLOAD = 8 * 1024 * 1024        # 单文件上限 8MB

# 允许在线预览的文本类扩展名
TEXT_EXTS = {
    ".py", ".java", ".js", ".ts", ".jsx", ".tsx", ".vue", ".go",
    ".html", ".css", ".json", ".md", ".txt", ".sql", ".xml",
    ".yml", ".yaml", ".sh", ".bat", ".c", ".cpp", ".h", ".ini",
    ".cfg", ".toml", ".properties",
}
