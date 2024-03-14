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
    local clients is_mpv addresses_positions hypr_cmd
    clients=$(hyprctl clients -j)
    is_mpv=$(jq -r ".[] | select(.address == \"0x$WINDOWADDRESS\" and .initialClass == \"mpv\")" <<< "$clients")

    if [[ "$is_mpv" == "" ]]; then
        mapfile -t addresses_positions < <(jq -r '[.[] | select(.class == "mpv")] | sort_by(.at[1]) | .[] | "\(.address) \(.at[0]) \(.at[1])"' <<< "$clients")  
        if [[ ${#addresses_positions[@]} -gt 0 ]]; then
            read -r address1 width1 height1 <<< "${addresses_positions[0]}"
            pid=$(jq -r ".[] | select(.address == \"$address1\") | .pid" <<< "$clients") 
            mpvplaycontrol "$pid" "$clients"

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
