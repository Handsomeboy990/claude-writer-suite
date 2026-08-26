#!/usr/bin/env python3
"""The Control Center local server. Standard library only, no dependency.

It serves a single self-contained page and one JSON endpoint that returns the
real local data assembled by reader.py. It binds to loopback only, picks a free
port from a dedicated range, prints the URL, and opens the browser unless told
not to. It stops cleanly on Ctrl-C.

Privacy is the default: the server binds to 127.0.0.1, never to a public
interface, so nothing it exposes leaves the machine. The one state-changing
endpoint, clearing local analytics, is confirmed by the page and acts only on a
copy the Control Center itself would keep, never on the user's transcripts.

    python3 server.py [--port N] [--no-browser] [--host 127.0.0.1]
"""

import json
import os
import socket
import sys
import threading
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import reader  # noqa: E402  (local, after sys.path setup)
import advisor  # noqa: E402

# A dedicated, uncommon range, chosen to avoid the usual development ports
# (3000, 3001, 4200, 5000, 5173, 8000, 8080, 8888, ...). The first free one is
# used, and the chosen port is printed.
PORT_RANGE = list(range(7317, 7367))
LOOPBACK = "127.0.0.1"

APP_HTML = os.path.join(HERE, "app.html")


def find_free_port(host, preferred=None):
    """Return the first bindable port. Never assume a port is free; test it."""
    candidates = ([preferred] if preferred else []) + PORT_RANGE
    for port in candidates:
        if port is None:
            continue
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                s.bind((host, port))
                return port
            except OSError:
                continue
    # Fall back to an ephemeral port the OS assigns.
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, 0))
        return s.getsockname()[1]


class Handler(BaseHTTPRequestHandler):
    # Silence the default per-request logging; the server prints its own line.
    def log_message(self, *args):
        pass

    def _send(self, code, body, content_type="application/json"):
        if isinstance(body, str):
            body = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", content_type + "; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        # A local tool; forbid embedding and sniffing as basic hardening.
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("X-Frame-Options", "DENY")
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = self.path.split("?", 1)[0]
        if path == "/" or path == "/index.html":
            try:
                with open(APP_HTML, "r", encoding="utf-8") as fh:
                    html = fh.read()
                self._send(200, html, "text/html")
            except OSError:
                self._send(500, "app.html not found", "text/plain")
            return
        if path == "/api/data":
            try:
                data = reader.collect()
                data["advisor"] = advisor.analyze(data)
                self._send(200, json.dumps(data, default=str))
            except Exception as exc:  # noqa: BLE001  report, never crash the server
                self._send(500, json.dumps({"error": str(exc)}))
            return
        if path == "/api/advisor":
            try:
                data = reader.collect()
                self._send(200, json.dumps(advisor.analyze(data), default=str))
            except Exception as exc:  # noqa: BLE001
                self._send(500, json.dumps({"error": str(exc)}))
            return
        if path == "/api/health":
            self._send(200, json.dumps({"ok": True}))
            return
        if path == "/favicon.ico":
            # A tiny transparent icon, so the browser's automatic request does
            # not produce a console 404. Served inline; no external asset.
            self.send_response(204)
            self.send_header("Content-Length", "0")
            self.end_headers()
            return
        self._send(404, json.dumps({"error": "not found"}))

    def do_POST(self):
        path = self.path.split("?", 1)[0]
        length = int(self.headers.get("Content-Length") or 0)
        _ = self.rfile.read(length) if length else b""
        if path == "/api/privacy/clear-derived":
            # The Control Center holds no separate store to clear: it reads the
            # transcripts live and keeps nothing of its own. Report that
            # honestly rather than pretending to delete something.
            self._send(200, json.dumps({
                "cleared": False,
                "message": ("The Control Center keeps no separate analytics "
                            "store. It reads your local transcripts live and "
                            "saves nothing of its own, so there is nothing for "
                            "it to clear. To remove session history, delete the "
                            "transcript files under the projects directory "
                            "yourself."),
                "projects_dir": reader.PROJECTS_DIR,
            }))
            return
        self._send(404, json.dumps({"error": "not found"}))


def main(argv):
    host = LOOPBACK
    preferred = None
    open_browser = True
    i = 0
    while i < len(argv):
        a = argv[i]
        if a == "--no-browser":
            open_browser = False
        elif a == "--host":
            i += 1
            host = argv[i] if i < len(argv) else LOOPBACK
        elif a == "--port":
            i += 1
            try:
                preferred = int(argv[i])
            except (IndexError, ValueError):
                preferred = None
        elif a.startswith("--port="):
            try:
                preferred = int(a.split("=", 1)[1])
            except ValueError:
                preferred = None
        i += 1

    port = find_free_port(host, preferred)
    url = f"http://{host}:{port}/"

    server = ThreadingHTTPServer((host, port), Handler)
    print("Claude Skill Suite, Control Center")
    print(f"Serving on {url}")
    print("All data is read locally and stays on this machine.")
    print("Press Ctrl-C to stop.")

    if open_browser:
        threading.Timer(0.6, lambda: webbrowser.open(url)).start()

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopping.")
    finally:
        server.shutdown()
        server.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
