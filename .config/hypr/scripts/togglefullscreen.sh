#!/bin/bash
#
mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | .pid' <<< "$2" | while read -r pid; do 
        if [ "$pid" == "$1" ]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$1"

        else
            echo '{ "command": ["set_property", "pause", true] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done
}

clients=$(hyprctl clients -j)
mapfile -t addresses_positions < <(jq -r '[.[] | select(.class == "mpv")] | sort_by(.at[1]) | .[] | "\(.address) \(.at[1])"' <<< "$clients")  

if [[ "${#addresses_positions[@]}" -eq 0 ]];then
    exit
fi

read -r next_address height <<< "${addresses_positions[0]}"

if [[ "$height" -eq 0 ]]; then
    hypr_cmd="dispatch fullscreen; dispatch pin address:$next_address;"

	if [[ ${#addresses_positions[@]} -gt 1 ]];then
	    addresses_positions=("${addresses_positions[@]:1}")
        if [[ ${addresses_positions[0]#* } -eq 20 && ${addresses_positions[1]#* } -eq 620 ]]; then
	        read -r next_address _ <<< "${addresses_positions[1]}"
        else
	        read -r next_address _ <<< "${addresses_positions[0]}"
        fi
        pid=$(jq -r ".[] | select(.address == \"$next_address\") | .pid" <<< "$clients") 
        mpvplaycontrol "$pid" "$clients"
    else
        hyprctl --batch ""$hypr_cmd" dispatch focuscurrentorlast"
        exit
	fi
fi

hypr_cmd+="dispatch focuswindow address:$next_address; dispatch pin address:$next_address; dispatch fullscreen"
hyprctl --batch "$hypr_cmd"

