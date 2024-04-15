#!/bin/bash
set -e

clients=$(hyprctl clients -j)

mapfile -t addresses_positions < <(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.at[1])"' <<< "$clients")

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
