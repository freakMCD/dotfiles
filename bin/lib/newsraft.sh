#!/bin/bash

newsraft="footclient --app-id=newsraftsilent newsraft"
retry_count=10
ping_target="google.com"
retry_interval=35

sleep 3

# Retry loop
for ((i=0; i<retry_count; i++)); do
    # Check for internet connectivity
    if ping -i 10 -c 3 -W 1 $ping_target | grep -q "0% packet loss"; then
        $newsraft &
        echo "Connection established. Launching newsraft."
        exit 0
    fi
    echo "Connection not yet established. Retrying in $retry_interval seconds..."
    sleep $retry_interval
done

notify-send "Newsraft wasn't launched"
