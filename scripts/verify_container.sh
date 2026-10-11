#!/usr/bin/env bash
set -euo pipefail
container="${1:-sarsembayev-eldar-container}"
for attempt in $(seq 1 30); do
  status="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container")"
  if [[ "$status" == healthy ]]; then
    docker exec "$container" python -c '
import json, os, urllib.request
with urllib.request.urlopen("http://127.0.0.1:8080/api/student", timeout=3) as response:
    data = json.load(response)
for key, variable in {"name":"STUDENT_NAME", "surname":"STUDENT_SURNAME", "group":"STUDENT_GROUP", "student_id":"STUDENT_ID"}.items():
    assert data[key] == os.environ[variable], (key, data[key])
assert data["message"] == "Application is running successfully!"
print(json.dumps(data, ensure_ascii=False, indent=2))
print("Container health and personalized data: PASS")
'
    exit 0
  fi
  if [[ "$status" == exited || "$status" == dead || "$status" == unhealthy ]]; then
    docker logs "$container" >&2
    echo "Container failed: $status" >&2; exit 1
  fi
  sleep 2
done
docker logs "$container" >&2
echo 'Timed out waiting for healthy container.' >&2
exit 1

