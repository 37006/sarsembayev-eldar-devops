"""Small standard-library HTTP application for a local teaching laboratory."""
from __future__ import annotations

import configparser
import html
import json
import logging
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlsplit

ROOT = Path(__file__).resolve().parents[1]
SUCCESS_MESSAGE = "Application is running successfully!"


def student_data(config_path: Path | None = None) -> dict[str, str]:
    config = configparser.ConfigParser()
    loaded = config.read(config_path or ROOT / "config" / "app.conf", encoding="utf-8")
    if not loaded:
        raise FileNotFoundError("Student configuration file was not found")
    keys = {
        "name": "STUDENT_NAME",
        "surname": "STUDENT_SURNAME",
        "group": "STUDENT_GROUP",
        "student_id": "STUDENT_ID",
    }
    return {key: os.environ.get(variable, config["student"][key])
            for key, variable in keys.items()}


def render_page(student: dict[str, str]) -> str:
    rows = "".join(
        f"<tr><th>{label}</th><td>{html.escape(student[key])}</td></tr>"
        for label, key in [("Name", "name"), ("Surname", "surname"),
                           ("Group", "group"), ("Student ID", "student_id")]
    )
    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Eldar Sarsembayev | DevOps Lab</title>
<style>
body{{font-family:Arial,sans-serif;background:#f3f5f7;color:#17232e;
margin:0;padding:48px 20px}}main{{max-width:660px;margin:auto;background:white;
padding:36px;border-radius:14px}}h1{{font-size:28px;margin-top:0}}
table{{border-collapse:collapse;width:100%}}td,th{{text-align:left;
padding:12px 0;border-bottom:1px solid #e6eaee}}th{{width:35%}}
.ok{{color:#17633d;background:#eef8f1;padding:16px;border-radius:8px}}
footer{{margin-top:24px;color:#5d6974;font-size:14px}}a{{color:#245da0}}
</style></head><body><main><h1>DevOps laboratory work 1</h1>
<p class="ok">{SUCCESS_MESSAGE}</p><table>{rows}</table>
<footer>Linux - Git - GitHub - Docker - Jenkins<br>
<a href="/api/student">Student JSON</a> | <a href="/health">Health check</a>
</footer></main></body></html>"""


class Handler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        route = urlsplit(self.path).path
        if route == "/health":
            self.respond(200, json.dumps({"status": "ok"}), "application/json")
        elif route == "/api/student":
            payload = {**student_data(), "message": SUCCESS_MESSAGE}
            self.respond(200, json.dumps(payload, ensure_ascii=False), "application/json")
        elif route == "/":
            self.respond(200, render_page(student_data()), "text/html")
        else:
            self.respond(404, json.dumps({"error": "Not found"}), "application/json")

    def respond(self, status: int, text: str, mime: str) -> None:
        body = text.encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", f"{mime}; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format: str, *args: object) -> None:
        logging.info("HTTP %s", format % args)


def main() -> None:
    config = configparser.ConfigParser()
    config.read(ROOT / "config" / "app.conf", encoding="utf-8")
    host = os.environ.get("APP_HOST", config["application"]["host"])
    port = int(os.environ.get("APP_PORT", config["application"]["port"]))
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
    student = student_data()
    server = ThreadingHTTPServer((host, port), Handler)
    logging.info("Student: %s %s | Group: %s | ID: %s",
                 student["name"], student["surname"], student["group"], student["student_id"])
    logging.info("%s Listening on %s:%s", SUCCESS_MESSAGE, host, port)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        logging.info("Application stopped")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

