# Student application API

This documentation was added on development and merged into main.

| Method and route | Result |
| --- | --- |
| GET / | HTML page with student information and the required success message |
| GET /api/student | JSON: name, surname, group, student_id, message |
| GET /health | HTTP 200 and JSON status ok |
| GET /unknown | HTTP 404 and JSON error Not found |

Environment overrides: STUDENT_NAME, STUDENT_SURNAME, STUDENT_GROUP, STUDENT_ID.
Application binding: APP_HOST and APP_PORT. Config defaults: config/app.conf.
No credentials or authentication tokens are required for this local lab app.
Every HTML student value is escaped. The server is for a local teaching lab.

Ports: app 8080 inside the container, manual/Compose host 8081, Jenkins host 8082.
The pipeline verifies both health and the personalized JSON after deployment.
