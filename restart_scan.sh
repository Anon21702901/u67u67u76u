#!/bin/bash

SCREEN_NAME="scan"
INTERVAL=600

while true; do
    echo "Starte scan.sh in screen..."
    screen -dmS $SCREEN_NAME ./scan.sh

    sleep $INTERVAL

    echo "Beende screen $SCREEN_NAME..."
    screen -S $SCREEN_NAME -X quit

    sleep 1
done
