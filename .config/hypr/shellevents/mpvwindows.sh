mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$2" | while read -r address pid; do 
        if [ "$address" == "$1" ]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"

        else
            echo '{ "command": ["set_property", "pause", true] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done
}

event_openwindow() {
    case "$WINDOWCLASS" in
        mpv)
            clients=$(hyprctl clients -j)
            ((mpv_count++))
            mpvplaycontrol "0x$WINDOWADDRESS" "$clients"
            height=$((20 + ($mpv_count - 1) * 300))
            hyprctl --batch "dispatch movewindowpixel exact 1438 $height,address:0x$WINDOWADDRESS"
            addresses+=( "$WINDOWADDRESS" )
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
                ((mpv_count--))
            fi
        done
        addresses=("${addresses[@]}")

        if [[ -n ${addresses[@]} ]]; then
            # Check if the activewindow is MPV and fullscreen
			window_info=$(hyprctl activewindow -j)
			if jq -e '.fullscreen == true and .class == "mpv"' <<< "$window_info" >/dev/null; then
			    address=$(jq -r '.address' <<< "$window_info")
			    hyprctl --batch "dispatch fullscreen; dispatch pin address:$address; dispatch focuscurrentorlast; setprop address:$address nofocus 1"
			fi	

	        # Adjust window positions if there are remaining windows
            for ((i = 0; i < ${#addresses[@]}; i++)); do
                height=$((20 + $i * 300))
                hyprctl dispatch movewindowpixel exact 1438 "$height",address:"0x${addresses[$i]}"
            done
        fi
    else
        return 1
    fi
}
