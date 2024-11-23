source ~/.config/hypr/scripts/variables.sh

mpv_socket_dir="/tmp/mpvSockets"
mpv_addresses_file=/tmp/mpv_addresses

mpvplaycontrol() {
    while read -r address pid; do 
        echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done <<< "$(jq -r '.[] | select(.class == "mpv" and .address != "'"$1"'" ) | "\(.address) \(.pid)"' <<< "$2")"
}

assign_coordinates() {
    case $1 in
        1)
            x="$x1_coord"
            y="$y1_coord"
            ;;
        2)
            x="$x2_coord"
            y="$y2_coord"
            ;;
        3)
            x="$x3_coord"
            y="$y3_coord"
            ;;
        4)
            x="$x4_coord"
            y="$y4_coord"
            ;;
        *)
            # More than 4 mpv windows, just stack them
            x=0
            y=$((1080 + ($1 - 4) * 100))  # Stacking additional windows below the 3rd window
            ;;
    esac
}

event_openwindow() {
    case "$WINDOWCLASS" in
        mpv)
            clients=$(hyprctl clients -j)
            ((mpv_count++))
            assign_coordinates "$mpv_count"

            echo "mpv_$mpv_count=0x$WINDOWADDRESS" >> "$mpv_addresses_file"

            hyprctl --batch "dispatch movewindowpixel exact $x $y,address:0x$WINDOWADDRESS"
            addresses+=( "$WINDOWADDRESS" )
            mpvplaycontrol "0x$WINDOWADDRESS" "$clients"
            ;;
    esac
}

event_closewindow() {
    # Check if WINDOWADDRESS is in the array
    if [[ " ${addresses[@]} " =~ " $WINDOWADDRESS " ]]; then
        # Find and remove the closed window's address from the array
        for i in "${!addresses[@]}"; do
            if [[ "${addresses[$i]}" == "$WINDOWADDRESS" ]]; then
                unset "addresses[$i]"
                addresses=("${addresses[@]}")  # Re-index the array
                ((mpv_count--))
                break
            fi
        done

        # Handle cases based on the number of remaining addresses
        if [[ ${#addresses[@]} -gt 0 ]]; then
            # Check if the active window is MPV and fullscreen
            window_info=$(hyprctl activewindow -j)
            if jq -e '.fullscreen == 2 and .class == "mpv"' <<< "$window_info" >/dev/null; then
                address=$(jq -r '.address' <<< "$window_info")
                hyprctl --batch "dispatch fullscreen; dispatch pin address:$address; dispatch focuscurrentorlast; setprop address:$address nofocus 1"
            fi

            # Adjust window positions if there are remaining windows
            : > "$mpv_addresses_file"  # Clear the file
            output=()
            for ((i = 0; i < ${#addresses[@]}; i++)); do
                assign_coordinates "$((i + 1))"
                output+=("mpv_$((i + 1))=0x${addresses[$i]}")
                hyprctl dispatch movewindowpixel exact "$x $y", address:"0x${addresses[$i]}"
            done
            printf "%s\n" "${output[@]}" >> "$mpv_addresses_file"
        else
            # No addresses left, clear the file
            : > "$mpv_addresses_file"
        fi
    else
        return 1
    fi
}
