#!/bin/bash

SCREEN_NAME="scan"
INTERVAL=400

while true; do
    echo "s scan.sh in screen..."
    screen -dmS $SCREEN_NAME ./scan.sh

    sleep $INTERVAL

    echo "Beende screen $SCREEN_NAME..."
    screen -S $SCREEN_NAME -X quit

    sleep 1
done
