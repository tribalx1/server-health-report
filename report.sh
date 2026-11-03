#!/usr/bin/env bash
# Server health report - finish the TODOs, then push. See README.md.
set -euo pipefail

echo "== Host =="
hostname
uname -r
uptime -p

echo "== Disk =="
df -h

echo "== Memory =="
free -h

echo "== Top processes =="
ps -eo pid,comm,%cpu --sort=-%cpu | head -6
