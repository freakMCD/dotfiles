mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    jq -r '.[] | select(.class == "mpv") | .pid' <<< "$2" | while read -r pid; do 
        if [ "$pid" == "$1" ]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$1"

        else
            echo '{ "command": ["set_property", "pause", true] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done
}

event_openwindow() {
    case "$WINDOWCLASS" in
    mpv)
        local clients pid addresses_positions hypr_cmd
        clients=$(hyprctl clients -j)
        pid=$(jq -r ".[] | select(.address == \"0x$WINDOWADDRESS\") | .pid" <<< "$clients") 
        mpvplaycontrol "$pid" "$clients"
        addresses_positions=$(jq -r '.[] | select(.class=="mpv") | "\(.address) \(.at | @csv)"' <<< "$clients")
        while read -r address position; do
            if [ "$address" != "0x$WINDOWADDRESS" ];then
                local adjusted_position
                case "$position" in
                    *",20") adjusted_position="${position/,20/ 320}" 
                            ;;
                                 
                    *",320") adjusted_position="${position/,320/ 620}" ;;
                esac
                hypr_cmd+="dispatch movewindowpixel exact $adjusted_position,address:$address;"
            fi
        done <<< "$addresses_positions"
        hypr_cmd+="dispatch movewindowpixel exact 1438 20,address:0x$WINDOWADDRESS"
        hyprctl --batch "$hypr_cmd"
        ;;
    esac
}

event_closewindow() {
    local clients is_mpv
    clients=$(hyprctl clients -j)
    is_mpv=$(jq -r ".[] | select(.address == \"0x$WINDOWADDRESS\" and .initialClass == \"mpv\")" <<< "$clients")

    if [[ -n "$is_mpv" ]];then
        local window_y addresses_positions hypr_cmd 
        window_y=$(( $(jq -r ".[] | select(.address == \"0x$WINDOWADDRESS\") | .at[1]" <<< "$clients") - 132 ))
        addresses_positions=$(jq -r '.[] | select(.class=="mpv") | "\(.address) \(.at | @csv)"' <<< "$clients")
        if [[ -n "$addresses_positions" ]];then
            local current_window_y adjusted_position
            while read -r address position; do
                current_window_y=${position#*,}

                # Check if the window is below the closing window
                if [[ "$current_window_y" -ge "$window_y" ]]; then
                    case "$position" in
                        *",320") adjusted_position="${position/,320/ 20}" 
                                 target_pid=$(jq -r ".[] | select(.address == \"$address\") | .pid" <<< "$clients") 
                                 mpvplaycontrol "$target_pid" "$clients"
                                ;;
                                 
                        *",620") adjusted_position="${position/,620/ 320}" ;;
                    esac
                    hypr_cmd+="dispatch movewindowpixel exact $adjusted_position,address:$address;"
                fi      
            done <<< "$addresses_positions"
            hyprctl --batch "$hypr_cmd"
        fi
    fi
}

