#!/bin/bash
source ~/.config/hypr/scripts/variables.sh
source ~/.config/hypr/scripts/mpv_addresses

clients=$(hyprctl clients -j)

# Match the appropriate mpv address based on the argument
mpv_variable="mpv_$1"
target_address=${!mpv_variable}

[ -z "$target_address" ] && exit

# Determine the actual x_coord of the matched window
current_x_coord=$(jq -r --arg address "$target_address" '
    .[] | select(.address == $address) | .at[0]' <<< "$clients")

# Toggle the x-coordinate based on its current value
case "$current_x_coord" in
    "0")
        new_x_coord=$((-$mpv_width))
        ;;
    "$(($x1_coord-1920))")
        new_x_coord=$mpv_width
        ;;
    "$x1_coord")
        new_x_coord="$mpv_width"
        ;;
    "1920")
        new_x_coord=$((-$mpv_width))
        ;;
    *)
        exit 1
        ;;
esac

# Build and execute the command to move the window
hyprctl --batch "dispatch movewindowpixel ${new_x_coord} 0,address:${target_address}"

