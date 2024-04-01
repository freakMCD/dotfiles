#!/bin/bash
mpv_socket_dir="/tmp/mpvSockets"

# Function to control mpv playback
mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2" | while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then mpv_action="false"; else mpv_action="true"; fi
        echo '{ "command": ["set_property", "pause", '"$mpv_action"'] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done
}

clients=$(hyprctl clients -j)
mapfile -t addresses_positions < <(jq -r '[.[] | select(.class == "mpv" or .fullscreen == true)] | sort_by(.at[1]) | .[] | "\(.address) \(.at[1])"' <<< "$clients")  

[[ "${#addresses_positions[@]}" -eq 0 ]] && exit

read -r target_address y_coord <<< "${addresses_positions[0]}"

if [[ "$y_coord" -eq 0 ]]; then
    hypr_cmd="dispatch fullscreen; dispatch pin address:$target_address"
	addresses_positions=("${addresses_positions[@]:1}")

	if [[ ${#addresses_positions[@]} -gt 0 ]];then
        if [[ ${addresses_positions[0]#* } -eq 20 && ${addresses_positions[1]#* } -eq 620 ]]; then
	        target_address=${addresses_positions[1]% *}
        else
	        target_address=${addresses_positions[0]% *}
        fi
    else
        next_workspace=$(jq -r '.[] | select(.address == "'"${target_address}"'") | .workspace.id' <<< "$clients")
        jq -e --argjson workspace "$next_workspace" '.[] | select(.workspace.id == $workspace and .class != "mpv")' <<< "$clients" >/dev/null && hypr_cmd+="; dispatch focuscurrentorlast"
	fi
fi

if [[ ${#addresses_positions[@]} -gt 0 ]]; then
    mpvplaycontrol "$target_address" "$clients"
    hypr_cmd+=";dispatch focuswindow address:$target_address; dispatch pin address:$target_address; dispatch fullscreen"
fi
hyprctl --batch "$hypr_cmd"
