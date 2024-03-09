#!/bin/bash

is_fullscreen=$(hyprctl activewindow -j | jq -r 'select(.fullscreen == true)')
if [[ $is_fullscreen != "" ]]; then
    exit
fi 

# Find the addresses and positions of the active (non-hidden) mpv windows
addresses_positions=$(hyprctl clients -j | jq -r '.[] | select(.class=="mpv") | "\(.address) \(.at | @csv)"')
if [[ $addresses_positions == "" ]];then
    exit
fi

# Toggle x-coordinates based on addresses_positions
toggle_x_coordinates() {
    local address="$1"
    local current_position="$2"

    case "$current_position" in
        "1438,"*)
            new_position="${current_position/1438,/1900 }"
            ;;
        "1900,"*)
            new_position="${current_position/1900,/1438 }"
            ;;
    esac

    if [ -n "$new_position" ]; then
        hyprctl --batch "dispatch focuswindow address:$address; dispatch moveactive exact $new_position"
    fi
}

# Iterate over each address and position
while read -r address position; do
    toggle_x_coordinates "$address" "$position"
done <<< "$addresses_positions"
hyprctl dispatch focuscurrentorlast

