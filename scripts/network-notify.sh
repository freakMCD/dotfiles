#!/usr/bin/env bash

nmcli monitor | while read -r line; do
    case "$line" in
        *"Connectivity is now 'full'"*)
            notify-send "Network" "Internet connected"
            ;;
    esac
done
