#!/bin/bash

source ~/.config/hypr/scripts/variables.sh
[ "$#" -ne 2 ] && { echo "Usage: $0 x_coord y_coord"; exit 1; }

clients=$(hyprctl clients -j)
target_address=$(jq -r --argjson x "$1" --argjson y "$2" '
    .[] | select(.class == "mpv" and (
      (($x == 0 and (.at[0] == 0 or .at[0] == -448)) or 
       ($x == 1470 and (.at[0] == 1470 or .at[0] == 1918))) and .at[1] == $y)) | .address' <<< "$clients")

# Exit if no target address is found
[ -z "$target_address" ] && exit

# Determine the actual x_coord of the matched window
current_x_coord=$(jq -r --arg address "$target_address" '
    .[] | select(.address == $address) | .at[0]' <<< "$clients")

# Toggle the x-coordinate based on its current value
case "$current_x_coord" in
    "0")
        new_x_coord="$(($x1_coord-1918))"
        ;;
    "$(($x1_coord-1918))")
        new_x_coord="0"
        ;;
    "$x1_coord")
        new_x_coord="1918"
        ;;
    "1918")
        new_x_coord="$x1_coord"
        ;;
    *)
        exit 1
        ;;
esac

# Build and execute the command to move the window
hyprctl --batch "dispatch movewindowpixel exact ${new_x_coord} $2,address:${target_address}"

