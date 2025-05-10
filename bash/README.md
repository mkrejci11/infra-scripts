# Bash Scripts

## performance.sh

### What this script does:

- Connects via SSH to predefined servers.
- On each server, it performs:
  - Hostname and uptime check.
  - Disk, memory, and CPU usage check.
  - Lists running `systemd` services.
- Saves all output to logs in `/var/log/performance_task`.
- Uses `tee` so that:
  - Output is visible in the terminal when run manually.
  - It can also be used in automated environments like `cron`.

