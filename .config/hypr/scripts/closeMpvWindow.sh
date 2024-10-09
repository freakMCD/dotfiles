#!/bin/bash
set -e
source ~/.config/hypr/scripts/variables.sh
source /tmp/mpv_addresses

# Match the appropriate mpv address based on the argument
mpv_variable="mpv_$1"
# Use indirect expansion to get the address dynamically
target_address=${!mpv_variable}

# Check if target_address is empty
if [[ -z "$target_address" ]]; then
    exit 1
fi

hyprctl dispatch closewindow address:$target_address
