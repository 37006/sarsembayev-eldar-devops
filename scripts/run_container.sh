#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
image="${1:-sarsembayev-eldar-devops:latest}"
container="${CONTAINER_NAME:-sarsembayev-eldar-container}"
host_port="${HOST_PORT:-8081}"
export STUDENT_NAME="${STUDENT_NAME:-Eldar}"
export STUDENT_SURNAME="${STUDENT_SURNAME:-Sarsembayev}"
export STUDENT_GROUP="${STUDENT_GROUP:-IT2-2301}"
export STUDENT_ID="${STUDENT_ID:-37006}"
if docker container inspect "$container" >/dev/null 2>&1; then
  owner="$(docker inspect --format '{{index .Config.Labels "lab.owner"}}' "$container")"
  if [[ "$owner" != sarsembayev-eldar-devops ]]; then
    echo "Refusing to replace unrelated container: $container" >&2; exit 1
  fi
  docker rm -f "$container"
fi
docker run -d --restart unless-stopped --name "$container" --label lab.owner=sarsembayev-eldar-devops \
  -p "127.0.0.1:${host_port}:8080" \
  -e STUDENT_NAME -e STUDENT_SURNAME -e STUDENT_GROUP -e STUDENT_ID "$image"
bash scripts/verify_container.sh "$container"
docker ps --filter "name=^/${container}$"
docker logs "$container"
