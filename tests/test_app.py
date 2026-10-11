"""Real configuration and HTTP tests, using only Python's standard library."""
import json
import os
import threading
import unittest
from http.server import ThreadingHTTPServer
from pathlib import Path
from unittest.mock import patch
from urllib.error import HTTPError
from urllib.request import urlopen

from app.main import Handler, SUCCESS_MESSAGE, render_page, student_data

VARIABLES = ["STUDENT_NAME", "STUDENT_SURNAME", "STUDENT_GROUP", "STUDENT_ID"]


class ConfigurationTests(unittest.TestCase):
    def test_personal_defaults(self):
        with patch.dict(os.environ, {}, clear=True):
            self.assertEqual(student_data(), {
                "name": "Eldar", "surname": "Sarsembayev",
                "group": "IT2-2301", "student_id": "37006"})

    def test_all_environment_overrides(self):
        overrides = dict(zip(VARIABLES, ["Demo", "Student", "TEST-GROUP", "99999"]))
        with patch.dict(os.environ, overrides):
            self.assertEqual(student_data(), {
                "name": "Demo", "surname": "Student",
                "group": "TEST-GROUP", "student_id": "99999"})

    def test_one_override_preserves_other_defaults(self):
        with patch.dict(os.environ, {"STUDENT_GROUP": "NEW-GROUP"}, clear=True):
            self.assertEqual(student_data()["name"], "Eldar")
            self.assertEqual(student_data()["group"], "NEW-GROUP")

    def test_missing_config_fails_explicitly(self):
        with self.assertRaises(FileNotFoundError):
            student_data(Path("definitely-missing-lab.conf"))

    def test_html_escapes_user_input(self):
        student = {"name": "<script>alert(1)</script>", "surname": "A&B",
                   "group": '"G"', "student_id": "37006"}
        page = render_page(student)
        self.assertNotIn("<script>", page)
        self.assertIn("&lt;script&gt;", page)
        self.assertIn("A&amp;B", page)

    def test_html_has_required_message(self):
        self.assertIn(SUCCESS_MESSAGE, render_page(student_data()))


class HttpTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        cls.thread = threading.Thread(target=cls.server.serve_forever, daemon=True)
        cls.thread.start()
        cls.base = f"http://127.0.0.1:{cls.server.server_port}"

    @classmethod
    def tearDownClass(cls):
        cls.server.shutdown()
        cls.server.server_close()
        cls.thread.join(timeout=3)

    def test_homepage(self):
        with urlopen(self.base + "/", timeout=5) as response:
            self.assertEqual(response.status, 200)
            self.assertIn("text/html", response.headers["Content-Type"])
            self.assertIn(SUCCESS_MESSAGE, response.read().decode())

    def test_health(self):
        with urlopen(self.base + "/health", timeout=5) as response:
            self.assertEqual(json.load(response), {"status": "ok"})

    def test_student_json(self):
        with patch.dict(os.environ, {}, clear=True):
            with urlopen(self.base + "/api/student", timeout=5) as response:
                data = json.load(response)
                self.assertEqual(data["student_id"], "37006")
                self.assertEqual(data["surname"], "Sarsembayev")
                self.assertEqual(data["message"], SUCCESS_MESSAGE)

    def test_http_uses_environment(self):
        with patch.dict(os.environ, {"STUDENT_GROUP": "HTTP-TEST"}):
            with urlopen(self.base + "/api/student", timeout=5) as response:
                self.assertEqual(json.load(response)["group"], "HTTP-TEST")

    def test_missing_route(self):
        with self.assertRaises(HTTPError) as context:
            urlopen(self.base + "/missing", timeout=5)
        self.assertEqual(context.exception.code, 404)
        self.assertEqual(json.loads(context.exception.read()), {"error": "Not found"})


if __name__ == "__main__":
    unittest.main()

