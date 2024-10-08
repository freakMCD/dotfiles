#!/bin/bash
source ~/.config/hypr/scripts/variables.sh
source /tmp/mpv_addresses
mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    clients=$(hyprctl clients -j)
    while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then
            target_pid="$pid"
  #      else
#            echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done <<< "$(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$clients")"
    
    if [ -n "$target_pid" ]; then
            sleep 0.1
            echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
    fi
}

# Match the appropriate mpv address based on the argument
mpv_variable="mpv_$1"
# Use indirect expansion to get the address dynamically
target_address=${!mpv_variable}

if [[ -z "$target_address" ]]; then
    exit 1
fi

mpvplaycontrol "$target_address"

