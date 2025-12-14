#!/bin/bash

# ==============================
# Configuration
# ==============================
SCREEN_NAME="scan"
INTERVAL=400
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="restart_scan.log"

echo "$(date) - HARD restart watchdog started" | tee -a "$LOG"

while true; do
    echo "$(date) - FORCE killing old scan processes..." | tee -a "$LOG"

    # Kill screen session (if exists)
    screen -S "$SCREEN_NAME" -X quit 2>/dev/null

    # Kill EVERYTHING started by scan.sh (zmap, awk, android)
    pkill -9 -f "$BASE_DIR/scan.sh" 2>/dev/null
    pkill -9 -f "$BASE_DIR/android" 2>/dev/null
    pkill -9 -f "zmap -p 5555" 2>/dev/null
    pkill -9 -f "awk {print \$1\":5555\"}" 2>/dev/null

    sleep 2

    echo "$(date) - Starting fresh scan..." | tee -a "$LOG"

    # Start scan.sh in detached screen
    screen -dmS "$SCREEN_NAME" bash -c "cd '$BASE_DIR' && ./scan.sh"

    echo "$(date) - Scan running, next restart in $INTERVAL seconds" | tee -a "$LOG"
    echo "----------------------------------------" | tee -a "$LOG"

    sleep "$INTERVAL"
done
