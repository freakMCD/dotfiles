#!/bin/bash
source ~/.config/hypr/scripts/variables.sh
source /tmp/mpv_addresses

# Match the appropriate mpv address based on the argument
mpv_variable="mpv_$1"
target_address=${!mpv_variable}

mpvplaycontrol() {
    while read -r address pid; do 
        echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done <<< "$(jq -r '.[] | select(.class == "mpv" and .address != "'"$1"'" ) | "\(.address) \(.pid)"' <<< "$2")"
}

[ -z "$target_address" ] && exit

clients=$(hyprctl clients -j)

# Determine the actual x_coord of the matched window
current_x_coord=$(jq -r --arg address "$target_address" '
    .[] | select(.address == $address) | .at[0]' <<< "$clients")

# Toggle the x-coordinate based on its current value
case "$current_x_coord" in
    "$x_offset")
        new_x_coord=$((-$mpv_width))
        ;;
    "$l_hidden")
        new_x_coord=$mpv_width
        ;;
    "$x1_coord")
        new_x_coord="$mpv_width"
        ;;
    "$r_hidden")
        new_x_coord=$((-$mpv_width))
        ;;
    *)
        exit 1
        ;;
esac

# Build and execute the command to move the window
hyprctl --batch "dispatch movewindowpixel ${new_x_coord} 0,address:${target_address}"
#if [[ $new_x_coord -ge 0 && $new_x_coord -le 1920 ]]; then
 #   mpvplaycontrol "$target_address" "$clients"
#fi

