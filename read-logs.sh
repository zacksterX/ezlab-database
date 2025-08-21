#!/bin/bash
LOG_DIR="/var/log/liquibase"

if [ "$1" = "-f" ]; then
    # Follow mode for latest log
    LATEST_LOG=$(ls -t "$LOG_DIR"/liquibase_*.log 2>/dev/null | head -n1)
    if [ -n "$LATEST_LOG" ]; then
        tail -f "$LATEST_LOG"
    else
        echo "No log files found in $LOG_DIR"
    fi
else
    # Show specific log or latest log
    if [ -n "$1" ]; then
        LOG_FILE="$LOG_DIR/liquibase_$1.log"
        if [ -f "$LOG_FILE" ]; then
            cat "$LOG_FILE"
        else
            echo "Log file not found: $LOG_FILE"
            echo "Available logs:"
            ls -la "$LOG_DIR"/liquibase_*.log 2>/dev/null || echo "No log files found"
        fi
    else
        # Show latest log by default
        LATEST_LOG=$(ls -t "$LOG_DIR"/liquibase_*.log 2>/dev/null | head -n1)
        if [ -n "$LATEST_LOG" ]; then
            cat "$LATEST_LOG"
        else
            echo "No log files found in $LOG_DIR"
        fi
    fi
fi