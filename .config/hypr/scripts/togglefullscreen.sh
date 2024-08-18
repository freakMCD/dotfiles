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
        echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
    fi
}

clients=$(hyprctl clients -j)
# If there isn't any mpv window, exits the script
jq -e '.[] | select(.class == "mpv")' <<< "$clients" >/dev/null || exit

target_address=$(jq -r --argjson x_coord "$1" --argjson y_coord "$2" '.[] | select(.class == "mpv" and .at[0] == $x_coord and .at[1] == $y_coord) | .address' <<< "$clients")
fullscreen_address=$(hyprctl activewindow -j | jq -r 'select(.fullscreen == 2) | .address')

if [[ -z "$target_address" && -z "$fullscreen_address" ]]; then
    exit
fi

if [[ -n "$fullscreen_address" ]]; then
    # Check if the fullscreen window is an mpv window
    if jq -e --arg address "$fullscreen_address" '.[] | select(.address == $address and .class == "mpv")' <<< "$clients" >/dev/null; then
        hyprctl --batch "dispatch fullscreen address:$fullscreen_address; dispatch pin address:$fullscreen_address; dispatch focuscurrentorlast; setprop address:$fullscreen_address nofocus 1"
        [ -z "$target_address" ] && target_address=$(jq -r --argjson x_coord "$1" --argjson y_coord "$2" '.[] | select(.class == "mpv" and .at[0] == $x_coord and .at[1] == $y_coord) | .address' <<< "$(hyprctl clients -j)")
    else
       hyprctl --batch "dispatch fullscreen address:$fullscreen_address"
    fi

fi

if [[ "$target_address" != "$fullscreen_address" && -n "$target_address" ]]; then
   hypr_cmd+="setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch pin address:$target_address; dispatch fullscreen"
    [ -n "$hypr_cmd" ] && hyprctl --batch "$hypr_cmd"
    mpvplaycontrol  "$target_address" "$clients"
fi

