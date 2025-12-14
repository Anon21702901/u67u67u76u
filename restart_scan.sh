#!/bin/bash

# ==============================
# Configuration
# ==============================
SCREEN_NAME="scan"
INTERVAL=400            # seconds between restarts
LOG_FILE="restart_scan.log"

# ==============================
# Start loop
# ==============================
echo "========================================" | tee -a "$LOG_FILE"
echo "$(date) - Restart watchdog started" | tee -a "$LOG_FILE"
echo "Screen name : $SCREEN_NAME" | tee -a "$LOG_FILE"
echo "Interval    : $INTERVAL seconds" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

while true; do
    echo "$(date) - Starting scan.sh in screen session '$SCREEN_NAME'..." | tee -a "$LOG_FILE"

    # Kill old screen session if it still exists
    screen -S "$SCREEN_NAME" -X quit 2>/dev/null

    # Start scan.sh inside a detached screen and log output
    screen -dmS "$SCREEN_NAME" bash -c "./scan.sh | tee -a scan.log"

    echo "$(date) - scan.sh started successfully" | tee -a "$LOG_FILE"
    echo "$(date) - Next restart in $INTERVAL seconds" | tee -a "$LOG_FILE"

    # Wait before restart
    sleep "$INTERVAL"

    echo "$(date) - Stopping screen session '$SCREEN_NAME'..." | tee -a "$LOG_FILE"
    screen -S "$SCREEN_NAME" -X quit

    echo "$(date) - Screen session stopped" | tee -a "$LOG_FILE"
    echo "----------------------------------------" | tee -a "$LOG_FILE"

    sleep 1
done
