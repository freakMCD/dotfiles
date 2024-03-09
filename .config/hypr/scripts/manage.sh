#!/bin/bash

mpv_socket_dir="/tmp/mpvSockets"

parse_hyprctl_json() {
    jq -r "$1" <(hyprctl clients -j)
}

mpvplaycontrol() {
    target_pid=$1

    parse_hyprctl_json '.[] | select(.class == "mpv") | .pid' | while read -r pid; do
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
            target_address="0x$(echo "$1" | awk -F'[,>]' '{print $3}')"
            target_pid=$(parse_hyprctl_json ".[] | select(.address == \"$target_address\") | .pid")
            mpvplaycontrol "$target_pid"

            mpv_count=$(echo "$(hyprctl clients -j)" | jq '[.[] | select(.class == "mpv")] | length')
            hyprctl --batch "dispatch focuswindow address:$target_address; dispatch moveactive exact 1438 $((20 + 300 * (mpv_count - 1)))"
            hyprctl dispatch focuscurrentorlast
            ;;
        closewindow*)
            closing_address="0x${1#closewindow>>}"
            is_mpv=$(parse_hyprctl_json ".[] | select(.address == \"$closing_address\" and .initialClass == \"mpv\")")

            if [[ -n "$is_mpv" ]];then
                closing_window_y=$(parse_hyprctl_json ".[] | select(.address == \"$closing_address\") | .at[1]")
                addresses_positions=$(hyprctl clients -j | jq -r '.[] | select(.class=="mpv") | "\(.address) \(.at | @csv)"')
                if [[ -n "$addresses_positions" ]];then
                    while read -r address position; do
                        current_window_y=${position#*,}

                        # Check if the window is below the closing window
                        if [[ "$current_window_y" -ge "$closing_window_y" ]]; then
                            case "$position" in
                                *",320") adjusted_position="${position/,320/ 20}" ;;
                                *",620") adjusted_position="${position/,620/ 320}" ;;
                            esac
                            hyprctl --batch "dispatch focuswindow address:$address; dispatch moveactive exact $adjusted_position"
                        fi      
                    done <<< "$addresses_positions"

                    hyprctl dispatch focuscurrentorlast
                fi
            fi
            ;;
    esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
