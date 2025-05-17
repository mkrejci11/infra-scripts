#! /bin/bash

SERVERS=("server1.example.com" "server2.example.com")

LOG_DIR=/var/log
AGE_DAYS=30

mkdir -p /var/log/clean-log
LOG_FILE=/var/log/clean-log/clean_$(date +%Y%m%d-%H%M%S).log


for SERVER in "${SERVERS[@]}"; do
    echo "--- Clear logs on $SERVER ---" | tee -a "$LOG_FILE"
    echo "--- Date: $(date) ---" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'true'; then
        echo "Connected to $SERVER" | tee -a "$LOG_FILE"

        ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'bash -s' << ENDSSH | tee -a "$LOG_FILE"

echo "Deleting log files older than $AGE_DAYS in $LOG_DIR"
find "$LOG_DIR" -type f -mtime +$AGE_DAYS -exec rm -f {} \;
echo "Clearing completed"

ENDSSH
    else
        echo "Cannot connect to $SERVER" | tee -a "$LOG_FILE" 
    fi

        echo "Finished checking $SERVER" | tee -a "$LOG_FILE" 

done
