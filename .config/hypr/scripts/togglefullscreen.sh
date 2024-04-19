#!/bin/bash
mpv_socket_dir="/tmp/mpvSockets"
mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2" | while read -r address pid; do 
        if [[ "$address" == "$1" ]]; then mpv_action="false"; else mpv_action="true"; fi
        echo '{ "command": ["set_property", "pause", '"$mpv_action"'] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done
}

getFullscreenCoord() {
    local coords=()
    local expected_values=(20 320 620)

    for line in "$@"; do
        # Extract the coord
        coord="${line#* }"
        coords+=("$coord")
    done

    # Perform missing number check
    for expected_value in "${expected_values[@]}"; do
        if [[ ! " ${coords[@]} " =~ " $expected_value " ]]; then
            fullscreen_coord=$expected_value
            break
        fi
    done
}

clients=$(hyprctl clients -j)
# If there isn't any mpv window, exits the script
jq -e '.[] | select(.class == "mpv")' <<< "$clients" >/dev/null || exit

mapfile -t addresses_positions < <(jq -r '[.[] | select(.class == "mpv" or (.fullscreen == true and (.workspace.name | startswith("special:") | not)))] | sort_by(.at[1]) | .[] | "\(.address) \(.at[1])"' <<< "$clients")

read -r address y_coord <<< "${addresses_positions[0]}"
if [[ "$y_coord" -eq 0 ]]; then
    active_workspace=$(hyprctl activeworkspace -j | jq '.id')
    if jq -e '.[] | select(.workspace.id != '"$active_workspace"' and .address == "'"$address"'")' <<< "$clients"; then
        hypr_cmd="dispatch focuswindow address:$address;"
        getFullscreenCoord "${addresses_positions[@]}"
        [[ "$fullscreen_coord" == "$1" ]] && hyprctl --batch "$hypr_cmd" && exit
    fi
    hypr_cmd+="dispatch fullscreen; dispatch pin address:$address;"
    addresses_positions=("${addresses_positions[@]:1}")

    if [[ ${#addresses_positions[@]} -eq 0 ]];then
        # Check if there is another non mpv window in the same workspace to prevent a crash
        jq -e '.[] | select(.workspace.id == '"$active_workspace"' and .class != "mpv")' <<< "$clients" >/dev/null && hypr_cmd+="dispatch focuscurrentorlast;"
        hyprctl --batch "$hypr_cmd setprop address:$address nofocus 1"
        exit
    fi
    # Return focus only if the fullscreen window was MPV
    address_class=$(jq -r '.[] | select(.address == "'"${address}"'") | .class' <<< "$clients")
    [[ "$address_class" == "mpv" ]] && hypr_cmd+="dispatch focuscurrentorlast; setprop address:$address nofocus 1;"
fi

# Find the target address
for pair in "${addresses_positions[@]}"; do
    read -r address coordinate <<< "$pair"
    [[ "$coordinate" -eq "$1" ]] && target_address=$address && break
done

[[ -z "$target_address" ]] && hyprctl --batch "$hypr_cmd" && exit

hypr_cmd+="setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch pin address:$target_address; dispatch fullscreen"
mpvplaycontrol "$target_address" "$clients"
hyprctl --batch "$hypr_cmd"
