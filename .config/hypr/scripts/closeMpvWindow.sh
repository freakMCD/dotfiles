#!/bin/bash
set -e
source ~/.config/hypr/scripts/variables.sh

clients=$(hyprctl clients -j)

mapfile -t addresses_positions < <(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.at[0]) \(.at[1])"' <<< "$clients")

# Find the target address
for pair in "${addresses_positions[@]}"; do
    read -r address x_coord y_coord <<< "$pair"
    # Check if the y_coord matches and then check x_coord alternatives
    if [ "$y_coord" -eq "$2" ] && { 
        ([ "$1" -eq 0 ] && { [ "$x_coord" -eq 0 ] || [ "$x_coord" -eq $((x1_coord-1918)) ]; }) || 
        ([ "$1" -eq "$x1_coord" ] && { [ "$x_coord" -eq "$x1_coord" ] || [ "$x_coord" -eq 1918 ]; });
    }; then        target_address=$address
        break
    fi
done

if [[ -z "$target_address" ]];then
    exit
fi

hyprctl dispatch closewindow address:$target_address
