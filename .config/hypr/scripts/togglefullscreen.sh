#!/bin/bash
source /tmp/mpv_addresses

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
        echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
    fi
}

# Match the appropriate mpv address based on the argument
mpv_variable="mpv_$1"
target_address=${!mpv_variable}
[ -z "$target_address" ] && exit

clients=$(hyprctl clients -j)
fullscreen_address=$(hyprctl activewindow -j | jq -r 'select(.fullscreen == 2) | .address')
if [[ -n "$fullscreen_address" ]]; then
    if [[ $fullscreen_address == $target_address ]]; then
       hyprctl --batch "dispatch fullscreen address:$target_address; dispatch focuscurrentorlast; setprop address:$target_address nofocus 1"
       exit
    else
        # Check if the fullscreen window is an mpv window
        if jq -e --arg address "$fullscreen_address" '.[] | select(.address == $address and .class == "mpv")' <<< "$clients" >/dev/null; then
            hypr_cmd+="dispatch fullscreen address:$fullscreen_address; dispatch focuscurrentorlast; setprop address:$fullscreen_address nofocus 1;"
        else
           hypr_cmd+="dispatch fullscreen address:$target_address;"
        fi
    fi

fi
hypr_cmd+="setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch fullscreen"
hyprctl --batch "$hypr_cmd"
mpvplaycontrol "$target_address" "$clients"
