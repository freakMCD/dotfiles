mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    while read -r address pid; do 
        echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
    done <<< "$(jq -r '.[] | select(.class == "mpv" and .address != "'"$1"'" ) | "\(.address) \(.pid)"' <<< "$2")"
}

event_openwindow() {
    case "$WINDOWCLASS" in
        mpv)
            clients=$(hyprctl clients -j)
            ((mpv_count++))
            height=$((20 + ($mpv_count - 1) * 500))
            hyprctl --batch "dispatch movewindowpixel exact 1138 $height,address:0x$WINDOWADDRESS"
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
                height=$((20 + $i * 500))
                hyprctl dispatch movewindowpixel exact 1138 "$height",address:"0x${addresses[$i]}"
            done
        fi
    else
        return 1
    fi
}
