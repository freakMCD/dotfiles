#!/bin/bash
set -e

clients=$(hyprctl clients -j)

mapfile -t addresses_positions < <(jq -r '
    # Get the workspace of the first mpv window
    . as $clients | ($clients | map(select(.class == "mpv"))) | .[0].workspace.id as $mpv_workspace |
    # Select mpv or fullscreen windows on the same workspace as the first mpv window
    [$clients[] | select((.class == "mpv") or (.fullscreen == true and .workspace.id == $mpv_workspace))] |
    sort_by(.at[1]) | .[] | "\(.address) \(.at[1])"
' <<< "$clients")

# Find the target address
for pair in "${addresses_positions[@]}"; do
    read -r address coordinate <<< "$pair"
    # Check if the coordinate is equal to argument
    if [ "$coordinate" -eq "$1" ]; then
        target_address=$address
        break
    fi
done

if [[ -z "$target_address" ]];then
    exit
fi

hyprctl dispatch closewindow address:$target_address
