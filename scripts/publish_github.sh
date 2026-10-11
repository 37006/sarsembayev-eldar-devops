#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
read -r -p 'Your registered GitHub username: ' github_user
if [[ ! "$github_user" =~ ^[A-Za-z0-9][A-Za-z0-9-]*$ ]]; then
  echo 'Invalid GitHub username.' >&2; exit 1
fi
remote_url="https://github.com/${github_user}/sarsembayev-eldar-devops.git"
if git remote get-url origin >/dev/null 2>&1; then
  current="$(git remote get-url origin)"
  if [[ "$current" != "$remote_url" ]]; then
    echo "Existing origin differs: $current. Review it before changing." >&2; exit 1
  fi
else
  git remote add origin "$remote_url"
fi
git remote -v
git push -u origin main
git push origin development
printf '\nRepository URL: https://github.com/%s/sarsembayev-eldar-devops\n' "$github_user"

