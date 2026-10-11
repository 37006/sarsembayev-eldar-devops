#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
if [[ "$(uname -s)" != Linux ]]; then
  echo 'Run this script in your Linux system, not in Windows Git Bash.' >&2
  exit 1
fi
mkdir -p app scripts config logs backup reports/evidence
chmod 600 private.txt
chmod 644 public.txt
chmod 755 scripts/*.sh
if [[ ! -f .env ]]; then cp .env.example .env; chmod 600 .env; fi
if [[ ! -f logs/application.log ]]; then
  cat > logs/application.log <<'LOG'
INFO Application started
INFO User logged in
WARNING Configuration file missing
INFO Database connected
ERROR Database connection failed
INFO Application restarted
WARNING Memory usage is high
INFO Request received
ERROR Request failed
INFO Application stopped
LOG
fi
echo 'Linux demonstration files prepared.'
echo 'The application.log file is a teaching sample, not an execution record.'
ls -l private.txt public.txt scripts/Sarsembayev_Eldar_system.sh
printf '\nAvailable tools:\n'
for tool in bash git python3 docker; do
  if command -v "$tool" >/dev/null; then "$tool" --version; else
    echo "Missing required tool: $tool" >&2; exit 1
  fi
done
docker compose version
docker info --format 'Docker server: {{.ServerVersion}}'

