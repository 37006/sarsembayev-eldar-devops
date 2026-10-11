#!/usr/bin/env bash
# Read-only collection: no commits, remote pushes, builds or container deletion.
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
mkdir -p reports/evidence
output="reports/evidence/verification-$(date +%Y%m%d-%H%M%S).txt"
exec > >(tee "$output") 2>&1
printf 'Student: Eldar Sarsembayev | IT2-2301 | 37006\n'
date --iso-8601=seconds
uname -a
pwd
ls -la
ls -l private.txt public.txt scripts/Sarsembayev_Eldar_system.sh
git status --short
git branch
git log --graph --oneline --all -12
git remote -v
git check-ignore -v logs/application.log backup/demo/info-renamed.txt .env
python3 -m unittest discover -s tests -v
docker version
docker compose version
docker images sarsembayev-eldar-devops
docker ps -a --filter name=sarsembayev-eldar
if docker inspect sarsembayev-eldar-container >/dev/null 2>&1; then
  bash scripts/verify_container.sh
  docker logs sarsembayev-eldar-container
else
  echo 'Required container is absent. Docker/Jenkins run is not yet verified.'
fi
echo "Evidence file: $output"
echo 'Capture real Linux and Jenkins screenshots separately; this is a command transcript.'

