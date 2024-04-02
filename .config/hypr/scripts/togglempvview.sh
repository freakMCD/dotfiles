#!/bin/bash

# Find the addresses and positions of the active (non-hidden) mpv windows
addresses_positions=$(hyprctl clients -j | jq -r '.[] | select(.class=="mpv" and .fullscreen != "true") | "\(.address) \(.at | @csv)"')
if [[ $addresses_positions == "" ]];then
    exit
fi

# Toggle x-coordinates based on addresses_positions
toggle_x_coordinates() {
    local address="$1"
    local current_position="$2"

    case "$current_position" in
        "1438,"*)
            new_position="${current_position/1438,/1916 }"
            ;;
        "1916,"*)
            new_position="${current_position/1916,/1438 }"
            ;;
    esac

    if [ -n "$new_position" ]; then
        hyprctl_commands+="dispatch movewindowpixel exact $new_position,address:$address;"
    fi
}

# Iterate over each address and position
while read -r address position; do
    toggle_x_coordinates "$address" "$position"
done <<< "$addresses_positions"
hyprctl --batch ""$hyprctl_commands""

