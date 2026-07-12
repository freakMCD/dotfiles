#!/usr/bin/env bash

IFACE="enp34s0"
NOTIF_ID=9999
RENEGOTIATING=0

get_speed() {
    cat "/sys/class/net/$IFACE/speed" 2>/dev/null
}

ip monitor link dev "$IFACE" | while read -r line; do
    [[ $line != *LOWER_UP* ]] && continue

    speed=""

    for _ in {1..5}; do
        speed=$(get_speed)

        if [[ "$speed" =~ ^[0-9]+$ ]] && (( speed > 0 )); then
            break
        fi

        sleep 1
    done

    case "$speed" in
        10)
            if (( ! RENEGOTIATING )); then
                RENEGOTIATING=1

                notify-send \
                    -u critical \
                    -t 0 \
                    -r "$NOTIF_ID" \
                    "Network Warning" \
                    "Negotiated at 10 Mb/s. Renegotiating..."

                if sudo ethtool -r "$IFACE"; then
                    :
                else
                    RENEGOTIATING=0
                fi
            fi
            ;;

        100|1000|2500|5000|10000)
            RENEGOTIATING=0

            notify-send \
                -r "$NOTIF_ID" \
                -t 3000 \
                "Network" \
                "Connected at ${speed} Mb/s"
            ;;
    esac
done
