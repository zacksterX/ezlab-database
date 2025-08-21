#!/bin/bash
cd /opt/ezlab-database

while true; do
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    LOG_FILE="/var/log/liquibase/liquibase_${TIMESTAMP}.log"
    
    echo "$(date): Checking for changes..." >> "$LOG_FILE"
    
    # Проверка изменений и git pull (с таймаутом)
    echo "$(date): Checking git repository..." >> "$LOG_FILE"
    git fetch origin >> "$LOG_FILE" 2>&1
    
    if [[ $(git rev-parse HEAD) != $(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null) ]]; then
        echo "$(date): Changes detected. Pulling updates..." >> "$LOG_FILE"
        git pull origin main >> "$LOG_FILE" 2>&1 || git pull origin master >> "$LOG_FILE" 2>&1
        
        # Запуск liquibase update
        echo "$(date): Running liquibase update..." >> "$LOG_FILE"
        liquibase update >> "$LOG_FILE" 2>&1
        
        if [ $? -eq 0 ]; then
            echo "$(date): Liquibase update completed successfully" >> "$LOG_FILE"
        else
            echo "$(date): Liquibase update failed" >> "$LOG_FILE"
        fi
    else
        echo "$(date): No changes detected" >> "$LOG_FILE"
    fi
    
    echo "Log saved to: $LOG_FILE" >> "$LOG_FILE"
    sleep 10
done