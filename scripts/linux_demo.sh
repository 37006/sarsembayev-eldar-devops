#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
mkdir -p logs reports/evidence
exec > >(tee logs/linux-demo.log) 2>&1
set -x
pwd
ls -la
cd app
pwd
cd ..
mkdir -p backup/demo
touch backup/demo/empty.txt
cp Sarsembayev_Eldar_info.txt backup/demo/info-copy.txt
mv backup/demo/info-copy.txt backup/demo/info-renamed.txt
cat Sarsembayev_Eldar_info.txt
head -n 5 logs/application.log
tail -n 5 logs/application.log
rm backup/demo/empty.txt
find . -name 'Sarsembayev_Eldar_info.txt' -type f
find . -name 'application.log' -type f
grep 'ERROR' logs/application.log
grep 'WARNING' logs/application.log
grep -c 'ERROR' logs/application.log
tail -n 5 logs/application.log
chmod 600 private.txt
chmod 644 public.txt
ls -l private.txt public.txt
./scripts/Sarsembayev_Eldar_system.sh
ps
ps aux
ps -p $$ -o pid,user,pcpu,pmem,comm
top -b -n 1 | head -n 18 || true
set +x
echo 'Linux command transcript saved to logs/linux-demo.log.'
echo 'For the video, also open interactive top and exit using q.'
