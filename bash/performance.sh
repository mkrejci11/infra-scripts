#! /bin/bash
SERVERS=("server1.example.com" "server2.example.com")
LOG_FILE=/var/log/performance_task/performance_check_$(date +%Y%m%d-%H%M%S).log

for SRV in "${SERVERS[@]}";
do
    echo "=== Checking $SRV ===" | tee -a "$LOG_FILE"
    echo "Date: $(date)" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 root@"$SRV" 'true'; then
        echo "Pripojeno k $SRV" | tee -a "$LOG_FILE"

        ssh -o ConnectTimeout=20 root@"$SRV" 'bash -s' << 'ENDSSH' | tee -a "$LOG_FILE"
        echo "Hostname: $(hostname)"
        echo "Uptime: $(uptime)"
        echo "Disk usage:"
        df -h
        echo "Memory usage:"
        free -m
ENDSSH
else
    echo "Nepodarilo se pripojit k $SRV" | tee -a "$LOG_FILE" 
fi
    echo "Konec kontroly serveru $SRV" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
done
echo "Script dokoncen, vystup ulozen v $LOG_FILE"
