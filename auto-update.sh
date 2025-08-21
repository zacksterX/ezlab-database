#!/bin/bash
cd /opt/ezlab-database

while true; do
    git fetch origin
    if [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]]; then
        TIMESTAMP=$(date +"%Y%m%d%H%M%S")
        LOG_FILE="/var/log/liquibase/liquibase_${TIMESTAMP}.log"
        
        echo "$(date): Changes detected. Pulling updates..." >> "$LOG_FILE"
        git pull origin main >> "$LOG_FILE" 2>&1
        
        echo "$(date): Running liquibase update..." >> "$LOG_FILE"
        liquibase update >> "$LOG_FILE" 2>&1
        
        echo "$(date): Liquibase update completed" >> "$LOG_FILE"
        echo "Log saved to: $LOG_FILE" >> "$LOG_FILE"
    fi
    sleep 10
done