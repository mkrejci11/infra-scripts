#! /bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

SERVERS=("server1.example.com" "server2.example.com")

mkdir -p /var/log/performance_task #check dir

LOG_FILE=/var/log/performance_task/performance_check_$(date +%Y%m%d-%H%M%S).log

#colours, echo -e for escape sequence e.g. \ symbol and colours only if ouput is terminal
if [ -t 1 ]; then
RED='\e[31m'
RESET='\e[0m'
else
RED=''
RESET=''
fi

for SRV in "${SERVERS[@]}";
do
    echo "=== Checking $SRV ===" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 commonservices@"$SRV" 'true'; then
        echo -e "$RED Connected to $SRV $RESET" | tee -a "$LOG_FILE"

        ssh -o ConnectTimeout=20 commonservices@"$SRV" 'bash -s' << 'ENDSSH' | tee -a "$LOG_FILE"
        echo "Hostname: $(hostname)"
        echo "Uptime: $(uptime)"
        echo "--- Disk usage: ---"
        df -h
        echo "--- Memory usage: ---"
        free -m
        echo "--- CPU usage: ---"
        top -b -n1 | head -n 10
        echo "--- Running systemd services ---"
        systemctl list-units --type=service --state=running
ENDSSH
else
    echo "Failed to connect to $SRV" | tee -a "$LOG_FILE" 
fi


    echo "Finished checking $SRV" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

done

echo "Script completed, output saved to $LOG_FILE"
