#!/bin/bash
mpv_socket_dir="/tmp/mpvSockets"
mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2" | while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then mpv_action="false"; else mpv_action="true"; fi
        echo '{ "command": ["set_property", "pause", '"$mpv_action"'] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done
}

clients=$(hyprctl clients -j)

mapfile -t addresses_positions < <(jq -r '
    # Get the workspace of the first mpv window
    . as $clients | ($clients | map(select(.class == "mpv"))) | .[0].workspace.id as $mpv_workspace |
    # Select mpv or fullscreen windows on the same workspace as the first mpv window
    [$clients[] | select((.class == "mpv") or (.fullscreen == true and .workspace.id == $mpv_workspace))] |
    sort_by(.at[1]) | .[] | "\(.address) \(.at[1])"
' <<< "$clients")

[[ "${#addresses_positions[@]}" -eq 0 ]] && exit

read -r address y_coord <<< "${addresses_positions[0]}"

if [[ "$y_coord" -eq 0 ]]; then
    hypr_cmd="dispatch fullscreen; dispatch pin address:$address; setprop address:$address nofocus 1;"
	addresses_positions=("${addresses_positions[@]:1}")

    if [[ ${#addresses_positions[@]} -eq 0 ]];then
        next_workspace=$(jq -r '.[] | select(.address == "'"${address}"'") | .workspace.id' <<< "$clients")
        jq -e --argjson workspace "$next_workspace" '.[] | select(.workspace.id == $workspace and .class != "mpv")' <<< "$clients" >/dev/null && hypr_cmd+="; dispatch focuscurrentorlast"
    fi
fi

# Find the target address
for pair in "${addresses_positions[@]}"; do
    read -r address coordinate <<< "$pair"
    # Check if the coordinate is equal to argument
    if [ "$coordinate" -eq "$1" ]; then
        target_address=$address
        break
    fi
done

if [[ "$target_address" == "" ]];then
    hyprctl --batch "$hypr_cmd"
    exit
fi

hypr_cmd+="; setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch pin address:$target_address; dispatch fullscreen"
mpvplaycontrol "$target_address" "$clients"

hyprctl --batch "$hypr_cmd"
