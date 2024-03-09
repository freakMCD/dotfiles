#!/bin/bash

mpv_socket_dir="/tmp/mpvSockets"

mpvplaycontrol() {
    target_pid=$1

    jq -r '.[] | select(.class == "mpv") | .pid' <<< "$hyprctl_clients" | while read -r pid; do 
        if [ "$pid" == "$target_pid" ]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
        else
            echo '{ "command": ["set_property", "pause", true] }' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
        fi
    done
}

handle() {
    case $1 in
        openwindow\>\>*,*,mpv,*)
            hyprctl_clients=$(hyprctl clients -j)
            target_address="0x$(echo "$1" | awk -F'[,>]' '{print $3}')"
            target_pid=$(jq -r ".[] | select(.address == \"$target_address\") | .pid" <<< "$hyprctl_clients") 
            mpvplaycontrol "$target_pid"

            mpv_count=$(jq '[.[] | select(.class == "mpv")] | length' <<< "$hyprctl_clients")
            hyprctl --batch "dispatch focuswindow address:$target_address; dispatch moveactive exact 1438 $((20 + 300 * (mpv_count - 1))); dispatch focuscurrentorlast"
            ;;
        closewindow*)
            hyprctl_clients=$(hyprctl clients -j)
            closing_address="0x${1#closewindow>>}"
            is_mpv=$(jq -r ".[] | select(.address == \"$closing_address\" and .initialClass == \"mpv\")" <<< "$hyprctl_clients")

            if [[ -n "$is_mpv" ]];then
                closing_window_y=$(( $(jq -r ".[] | select(.address == \"$closing_address\") | .at[1]" <<< "$hyprctl_clients") - 132 ))
                addresses_positions=$(jq -r '.[] | select(.class=="mpv") | "\(.address) \(.at | @csv)"' <<< "$hyprctl_clients")
                if [[ -n "$addresses_positions" ]];then
                    while read -r address position; do
                        current_window_y=${position#*,}

                        # Check if the window is below the closing window
                        if [[ "$current_window_y" -ge "$closing_window_y" ]]; then
                            case "$position" in
                                *",320") adjusted_position="${position/,320/ 20}" ;;
                                *",620") adjusted_position="${position/,620/ 320}" ;;
                            esac
                            local hyprctl_commands+="dispatch focuswindow address:$address; dispatch moveactive exact $adjusted_position;"
                        fi      
                    done <<< "$addresses_positions"
                    echo $hyprctl_commands
                    hyprctl --batch ""$hyprctl_commands" dispatch focuscurrentorlast"
                fi
            fi
            ;;
    esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
