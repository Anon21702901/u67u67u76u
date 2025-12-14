#!/bin/bash

# ==============================
# Configuration
# ==============================
SCREEN_NAME="scan"
INTERVAL=400
LOG_FILE="restart_scan.log"

echo "========================================" | tee -a "$LOG_FILE"
echo "$(date) - HARD restart watchdog started" | tee -a "$LOG_FILE"
echo "Screen name : $SCREEN_NAME" | tee -a "$LOG_FILE"
echo "Interval    : $INTERVAL seconds" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

while true; do
    echo "$(date) - FORCE stopping old scan instances..." | tee -a "$LOG_FILE"

    # Kill screen session (if exists)
    screen -S "$SCREEN_NAME" -X quit 2>/dev/null

    # Kill ANY leftover scan.sh processes
    pkill -9 -f "./scan.sh" 2>/dev/null
    pkill -9 -f "scan.sh" 2>/dev/null

    sleep 2

    echo "$(date) - Starting scan.sh in fresh screen session..." | tee -a "$LOG_FILE"

    # Start clean
    screen -dmS "$SCREEN_NAME" bash -c "./scan.sh | tee -a scan.log"

    echo "$(date) - scan.sh started" | tee -a "$LOG_FILE"
    echo "$(date) - Will HARD restart again in $INTERVAL seconds" | tee -a "$LOG_FILE"
    echo "----------------------------------------" | tee -a "$LOG_FILE"

    sleep "$INTERVAL"
done
