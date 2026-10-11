#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
printf '==============================\nStudent Information\n==============================\n'
printf 'Name: Eldar\nSurname: Sarsembayev\nGroup: IT2-2301\nStudent ID: 37006\n'
printf '\n==============================\nSystem Information\n==============================\n'
printf '\nUsername: '; whoami
printf 'Hostname: '; hostname
printf 'Current Date: '; date --iso-8601=seconds
printf '\nOperating system:\n'; uname -a
if [[ -r /etc/os-release ]]; then cat /etc/os-release; fi
printf '\nDisk usage:\n'; df -h
printf '\nMemory usage:\n'; free -h
printf '\nPersonalized file check:\n'
if [[ -f "$project_dir/Sarsembayev_Eldar_info.txt" ]]; then
  echo 'Student information file exists.'
else
  echo 'Student information file does not exist.'
fi
