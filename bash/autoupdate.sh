#! /bin/bash

CHECK_SERVERS=("server1.example.com" "server2.eample.com")

LOG_DIR=/var/log/autoupdate
mkdir -p "$LOG_DIR"
LOG_FILE="LOG_DIR/autoupdate_$(date +%Y%m%d-%H%M%S).log"
