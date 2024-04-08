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
            local hypr_cmd addresses_widths height=20
            clients=$(hyprctl clients -j)
            mpv_count=$(jq -r '. | map(select(.class == "mpv" )) | length' <<< "$clients")
            mpvplaycontrol "0x$WINDOWADDRESS" "$clients"
            hypr_cmd+="dispatch movewindowpixel exact 1438 $height,address:0x$WINDOWADDRESS"

            addresses_widths=$(jq -r '[.[] | select(.class=="mpv" and .address != "0x'"$WINDOWADDRESS"'")] | sort_by(.at[1]) | .[] | "\(.address) \(.at[0])"' <<< "$clients")
            while read -r address width; do
                height=$((height + 300))
                hypr_cmd+=";dispatch movewindowpixel exact $width $height,address:$address"
            done <<< "$addresses_widths"

            hyprctl --batch "$hypr_cmd"
            ;;
    esac
}

event_closewindow() {
    local is_mpv addresses_positions hypr_cmd
    clients=$(hyprctl clients -j)
    count_after=$(jq -r '. | map(select(.class == "mpv" )) | length' <<< "$clients")

    if (( count_after == mpv_count -1 )); then
        mpv_count=$count_after
        if (( mpv_count > 0 ));then
            mapfile -t addresses_positions < <(jq -r '[.[] | select(.class == "mpv")] | sort_by(.at[1]) | .[] | "\(.address) \(.at[0]) \(.at[1])"' <<< "$clients")  
            read -r address1 width1 height1 <<< "${addresses_positions[0]}"
            mpvplaycontrol "$address1" "$clients"

            case "${#addresses_positions[@]}" in
                1)
                    if [[ $height1 -eq 320 ]]; then
                        hypr_cmd+="dispatch movewindowpixel exact $width1 20,address:$address1;"
                    fi
                    ;;
                2)
                    read -r address2 width2 height2 <<< "${addresses_positions[1]}"
                    if [[ $height2 -eq 620 ]];then
                        hypr_cmd+="dispatch movewindowpixel exact $width1 20,address:$address1;"
                        hypr_cmd+="dispatch movewindowpixel exact $width2 320,address:$address2;"
                    fi
                    ;;
            esac
            if [[ -n "$hypr_cmd" ]]; then
                hyprctl --batch ""$hypr_cmd""
            fi
        fi
    fi
}
