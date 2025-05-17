# Bash Scripts

## autoupdate.sh

### What this script does:

- Connects via SSH to predefined servers.
- On each server, it performs:
  - Checks for available updates using dnf check-update.
  - Installs all available updates using dnf -y update.
  - Installs only security updates using dnf update --security -y.
  - Displays the outcome of each operation (success, up-to-date, or errors).
- Logs all output to /var/log/autoupdate.
- Uses tee so that:
  - Output is visible in the terminal when run manually.
  - It can also be used in automated environments like cron.


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


## clean-logs.sh

### What this script does:

- Connects via SSH to predefined servers.
- On each server, it performs:
  - Deletes all files in /var/log that are older than a specified number of days (default is 30).
  - Uses find to identify and remove old log files based on modification time.
- Logs all output to /var/log/clean-log on the central server.
- Uses tee so that:
  - Output is visible in the terminal when run manually.
  - It can also be used in automated environments like cron.
