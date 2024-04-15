#!/bin/bash
mpv_socket_dir="/tmp/mpvSockets"
mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2" | while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then
           echo '{ "command": ["cycle", "pause"] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        else
           echo '{ "command": ["set_property", "pause", true] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"

        fi
    done
}

clients=$(hyprctl clients -j)

# Find the target address directly
target_address=$(jq -r --arg coord "$1" '.[] | select(.class == "mpv" and .at[1] == ($coord | tonumber)) | .address' <<< "$clients")

if [[ -z "$target_address" ]];then
    exit
fi

mpvplaycontrol "$target_address" "$clients"

