#!/bin/bash
mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then
            target_pid="$pid"
        else
            echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done <<< "$(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2")"
    
    if [ -n "$target_pid" ]; then
            sleep 0.1
            echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
    fi
}

clients=$(hyprctl clients -j)

# Adjust the filter to match x and y coordinates with alternatives
target_address=$(jq -r --argjson x_coord "$1" --argjson y_coord "$2" '
    .[] | select(.class == "mpv" and 
    ((($x_coord == 0 and (.at[0] == 0 or .at[0] == -460)) or 
      ($x_coord == 1620 and (.at[0] == 1620 or .at[0] == 1910))) and (.at[1] == $y_coord))
    ) | .address' <<< "$clients")

if [[ -z "$target_address" ]];then
    exit
fi

mpvplaycontrol "$target_address" "$clients"

