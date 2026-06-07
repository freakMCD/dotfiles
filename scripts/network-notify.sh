#!/usr/bin/env bash

IFACE="enp34s0"
NOTIF_ID=9999
RENEGOTIATING=0

while read -r line; do
    case "$line" in
        *LOWER_UP*)

            speed=""

            for _ in {1..5}; do
                speed=$(<"/sys/class/net/$IFACE/speed" 2>/dev/null)

                if [[ "$speed" =~ ^[0-9]+$ ]]; then
                    break
                fi

                sleep 1
            done

            if [[ "$speed" == "10" ]]; then

                if [[ "$RENEGOTIATING" -eq 0 ]]; then
                    RENEGOTIATING=1

                    notify-send \
                        -u critical \
                        -t 0 \
                        -r "$NOTIF_ID" \
                        "Network Warning" \
                        "Negotiated at 10 Mb/s. Renegotiating..."

                    sudo ethtool -r "$IFACE"
                fi

            elif [[ "$speed" == "100" ]]; then

                RENEGOTIATING=0

                notify-send \
                    -r "$NOTIF_ID" \
                    -t 3000 \
                    "Network" \
                    "Connected at ${speed} Mb/s"

            elif [[ "$speed" == "1000" ]]; then

                RENEGOTIATING=0

                notify-send \
                    -r "$NOTIF_ID" \
                    -t 3000 \
                    "Network" \
                    "Connected at ${speed} Mb/s"

            fi
            ;;
    esac
done < <(ip monitor link dev "$IFACE")
