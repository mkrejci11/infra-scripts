#! /bin/bash

SERVERS=("server1.example.com" "server2.example.com")

LOG_DIR=/var/log/autoupdate
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/autoupdate_$(date +%Y%m%d-%H%M%S).log"

for SERVER in "${SERVERS[@]}"; do
    echo "--- Checking $SERVER ---" | tee -a "$LOG_FILE"
    echo "--- Date: $(date) ---" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'true'; then
        echo "Connected to $SERVER" | tee -a "$LOG_FILE"

        ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'bash -s' << 'ENDSSH' | tee -a "$LOG_FILE"


#func to check for updates
check_updates() {
    echo "$(date) - Checking for updates"
    dnf check-update 2>&1
    STATUS=$?

    if [ $STATUS -eq 100 ]; then #100 = updates available 
        echo "Updates are available"
    elif [ $STATUS -eq 0 ]; then #0 = system is up to date, no updates available
        echo "System is up to date"
    else
        echo "Error checking for updates - exit code $STATUS" #1 or higher = an error
    fi  
}

#func to install updates
 install_updates() {
    echo "$(date) - Installing all available updates"
    dnf -y update 2>&1
    STATUS=$?

    if [ $STATUS -eq 0 ]; then
        echo "Updates were successfully installed" 
    else
        echo "Error during update installation" 
    fi
}  

#func to install security updates
install_security_updates() {
    echo "$(date) - Installing security updates"
    dnf update --security -y 2>&1
    STATUS=$?

    if [ $STATUS -eq 0 ]; then
        echo "Security updates were successfully installed"
    else
        echo "Error during security update installation - exit code $STATUS"
    fi
}

        check_updates

        install_updates

        install_security_updates

ENDSSH

    else
        echo "Cannot connect to $SERVER" | tee -a "$LOG_FILE" 
    fi

    echo "Finished checking $SERVER" | tee -a "$LOG_FILE"
 
done
