#! /bin/bash
SERVERS=(server1.example.com server2.example.com)

mkdir -p /var/log/check_service
LOG_FILE=/var/log/check_service/check_service_$(date +%Y%m%d-%H%M%S).log

for SERVER in "${SERVERS[@]}"; do
echo "--- Checking $SERVER ---" | tee -a "$LOG_FILE"
echo "--- Date: $(date) ---" | tee -a "$LOG_FILE"

    if ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'true'; then
    echo "Connected to $SERVER" | tee -a "$LOG_FILE"

    ssh -o ConnectTimeout=20 commonservices@"$SERVER" 'bash -s' << 'ENDSSH' | tee -a "$LOG_FILE"
    SERVICES=("nginx" "sshd" "mariadb")

    #check service status
for SERVICE in "${SERVICES[@]}"; do
    STATUS=$(systemctl is-active "$SERVICE")
        if [ "$STATUS" == "active" ]; then
            echo "Service $SERVICE is running" 
        else
            echo "Service $SERVICE is not running" 
            echo "Try to restart $SERVICE" 
            systemctl restart "$SERVICE"

            #check after restart
            NEW_STATUS=$(systemctl is-active "$SERVICE")
            if [ "$NEW_STATUS" == "active" ]; then
                echo "Service $SERVICE succesfuly restarted" 
            else
                echo "Service $SERVICE is still not running" 
            fi

        fi   
done
ENDSSH
    else
        echo "Cannot connect to $SERVER" | tee -a "$LOG_FILE"
    fi
    echo "Finished checking $SERVER" | tee -a "$LOG_FILE"

done


