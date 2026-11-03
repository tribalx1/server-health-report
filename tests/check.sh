#!/usr/bin/env bash
# AkOps Labs check for the Server health report project. Please don't edit this file.
set -uo pipefail

fail=0
pass() { echo "PASS  $1"; }
bad() { echo "FAIL  $1"; fail=1; }

[ -f report.sh ] && pass "report.sh exists" || { bad "report.sh exists"; exit 1; }
[ -x report.sh ] && pass "report.sh is executable" || bad "report.sh is executable (run: chmod +x report.sh, then commit)"
head -1 report.sh | grep -Eq '^#!(/usr/bin/env bash|/bin/bash)' && pass "starts with a bash shebang" || bad "starts with a bash shebang"
grep -Eq 'set -euo pipefail|set -o errexit' report.sh && pass "uses set -euo pipefail" || bad "uses set -euo pipefail"
grep -Eq '#[[:space:]]*TODO:' report.sh && bad "no # TODO: lines left in report.sh" || pass "no TODOs left"

out="$(bash report.sh 2>&1)"; code=$?
[ $code -eq 0 ] && pass "script exits with code 0" || bad "script exits with code 0 (got $code)"

prev=0
for h in "== Host ==" "== Disk ==" "== Memory ==" "== Top processes =="; do
  line=$(printf '%s\n' "$out" | grep -nF -- "$h" | head -1 | cut -d: -f1)
  if [ -n "$line" ] && [ "$line" -gt "$prev" ]; then pass "section '$h' in order"; prev=$line; else bad "section '$h' present and in order"; fi
done

section() { printf '%s\n' "$out" | awk -v s="$1" '$0==s{f=1;next} /^== .* ==$/{f=0} f'; }
section "== Host ==" | grep -q "$(uname -r)" && pass "Host shows the kernel version" || bad "Host shows the kernel version (uname -r)"
section "== Disk ==" | grep -Eq 'Filesystem|Use%' && pass "Disk shows df output" || bad "Disk shows df -h output"
section "== Memory ==" | grep -Eq 'Mem:' && pass "Memory shows free output" || bad "Memory shows free -h output"
n=$(section "== Top processes ==" | grep -cEv '^\s*$|PID')
[ "$n" -ge 3 ] && [ "$n" -le 6 ] && pass "Top processes lists about 5 processes" || bad "Top processes lists 5 processes (found $n lines)"

if command -v shellcheck >/dev/null; then
  shellcheck report.sh && pass "ShellCheck finds no problems" || bad "ShellCheck finds no problems"
fi

echo
[ $fail -eq 0 ] && echo "All checks passed. Push and submit your repo on AkOps Labs." || echo "Some checks failed. Fix them and push again."
exit $fail
