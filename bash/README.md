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

 ## check-service.sh

 ### What this script does:
- Connects via SSH to predefined servers.
- On each server, it performs:
  - Checks if specified services (nginx, sshd, mariadb) are running.
  - If any service is not running, it attempts to restart it and checks the result.
- Logs all output to /var/log/check_service.
- Uses tee so that:
  - Output is displayed in the terminal when run manually.
  - It can also be used in automated environments like cron.

