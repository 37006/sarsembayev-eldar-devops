#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
mkdir -p logs
exec > >(tee logs/docker-demo.log) 2>&1
export STUDENT_NAME=Eldar STUDENT_SURNAME=Sarsembayev
export STUDENT_GROUP=IT2-2301 STUDENT_ID=37006
set -x
docker build -t sarsembayev-eldar-devops:latest .
docker images sarsembayev-eldar-devops
bash scripts/run_container.sh
docker ps
docker ps -a
docker logs sarsembayev-eldar-container
docker exec sarsembayev-eldar-container id
docker exec sarsembayev-eldar-container printenv STUDENT_NAME STUDENT_SURNAME STUDENT_GROUP STUDENT_ID
docker stop sarsembayev-eldar-container
docker ps -a --filter name=sarsembayev-eldar-container
docker start sarsembayev-eldar-container
bash scripts/verify_container.sh
docker stop sarsembayev-eldar-container
docker rm sarsembayev-eldar-container
docker compose config
docker compose up -d --build
bash scripts/verify_container.sh sarsembayev-eldar-compose
docker compose ps
docker compose logs --no-color
docker compose down
# Restore the required personalized container after the demonstration.
bash scripts/run_container.sh
set +x
echo 'Docker demonstration finished; personalized container remains running.'

