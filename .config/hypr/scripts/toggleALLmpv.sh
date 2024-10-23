#!/bin/bash

source ~/.config/hypr/scripts/variables.sh
# Find the addresses and positions of the active (non-hidden) mpv windows
addresses_positions=$(hyprctl clients -j | jq -r '.[] | select(.class=="mpv" and .fullscreen != "true") | "\(.address) \(.at | @csv)"')
if [[ -z $addresses_positions ]];then
    exit
fi

# Toggle x-coordinates based on addresses_positions
toggle_x_coordinates() {
    local address="$1"
    local current_position="$2"

    case "$current_position" in
        "$x_offset,"*)
            new_position="${current_position/$x_offset,/$l_hidden }"
            ;;
        "$l_hidden,"*)
            new_position="${current_position/$l_hidden,/$x_offset }"
            ;;
        "$x1_coord,"*)
            new_position="${current_position/$x1_coord,/$r_hidden }"
            ;;
        "$r_hidden,"*)
            new_position="${current_position/$r_hidden,/$x1_coord }"
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
hyprctl --batch "$hyprctl_commands"

