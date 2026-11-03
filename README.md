# Server health report (AkOps Labs build project)

Write a Bash script that prints a short health report of a Linux server: who it is, how full the disks are,
how much memory is free and which processes use the most CPU. Ops teams run scripts like this every day.

**Level:** Beginner · **Time:** about 45 minutes · **Skills:** Bash, Linux commands, ShellCheck, GitHub Actions

## How this works

1. This is your own copy of the project: made with **Use this template** on GitHub, or pushed from the AkOps Labs browser terminal. Everything you do happens in your copy.
2. Work in **GitHub Codespaces** (Code → Codespaces → Create codespace) or clone it to any Linux/Mac machine.
3. Every push runs the **AkOps check** (`.github/workflows/akops-check.yml`). When it is green, your project is done.
4. Go back to your project page on AkOps Labs, paste your repository link and press **Check my project**.
   Then share your badge on LinkedIn.

> Don't edit `.github/workflows/akops-check.yml` or the `tests/` folder. They are how your work is checked.

## Your task

Finish `report.sh` so that it prints these four sections, in this order, with these exact headings:

```
== Host ==
== Disk ==
== Memory ==
== Top processes ==
```

| Section | What to print | Commands that help |
|---|---|---|
| Host | host name, kernel version, uptime | `hostname`, `uname -r`, `uptime -p` |
| Disk | usage of every mounted file system, human-readable | `df -h` |
| Memory | total, used and free memory, human-readable | `free -h` |
| Top processes | the 5 processes using the most CPU | `ps -eo pid,comm,%cpu --sort=-%cpu \| head -6` |

Rules:

- The script starts with `#!/usr/bin/env bash` and uses `set -euo pipefail`.
- It is executable (`chmod +x report.sh`) and exits with code 0.
- It passes [ShellCheck](https://www.shellcheck.net/) with no warnings.
- Bonus: add a `--json` flag later. It isn't checked, but it makes a nice interview story.

## Run the check yourself

```bash
chmod +x report.sh
./report.sh
bash tests/check.sh        # the same check GitHub runs
```

## Push and finish

```bash
git add report.sh
git commit -m "Server health report"
git push
```

Open the **Actions** tab: when **AkOps check** shows a green tick, go back to AkOps Labs and submit your repository link.

## Ideas for your LinkedIn post

- What each section tells an on-call engineer
- Why `set -euo pipefail` matters in production scripts
- What ShellCheck caught that you would have missed
