#! /bin/bash

SERVERS=("server1.example.com" "server2.eample.com")

LOG_DIR=/var/log/autoupdate
mkdir -p "$LOG_DIR"
LOG_FILE="LOG_DIR/autoupdate_$(date +%Y%m%d-%H%M%S).log"

#func for connect to servers and perform updates
update_system() {
    echo "--- Checking $SERVER ---" | tee -a "$LOG_FILE"
    echo "--- Date: $(date) ---" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'true'; then
        echo "Connected to $SERVER" | tee -a "$LOG_FILE"

        ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'bash -s' << 'ENDSSH' | tee -a "$LOG_FILE"
        
        check_updates

        install_updates

        install_security_updates

    ENDSSH

    else
        echo "Cannot connect to $SERVER" | tee -a "$LOG_FILE" 
    fi
    
    echo "Finished checking $SERVER" | tee -a "$LOG_FILE"
 
}
