{ pkgs, ... }: 
let
var = import ./variables.nix;
in
{
    home.packages = with pkgs; [
      jq socat
      (writeShellScriptBin "shellevents" ''
        PFS=$IFS

        load_events() {
          IFS=$PFS
          for f in $event_files; do
            # shellcheck disable=SC1090
            if . "$f"; then
              printf >&2 'loaded event file: %s\n' "$f"
            else
              printf >&2 'failed sourcing event file: %s\n' "$f"
              exit 2
            fi
          done
        }

        verbose=
        case "$1" in
        -v) verbose=1 && shift ;;
        esac

        event_files="$*"
        load_events

        trap 'load_events; continue' USR1

        mpv_socket_dir="/tmp/mpvSockets"
        mpv_addresses_file=/tmp/mpv_addresses

        mpvplaycontrol() {
            while read -r address pid; do 
                echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
            done <<< "$(jq -r '.[] | select(.class == "mpv" and .address != "'"$1"'" ) | "\(.address) \(.pid)"' <<< "$2")"
        }

        assign_coordinates() {
            case $1 in
                1)  x="${var.x1}" y="${var.y1}";;
                2)  x="${var.x2}" y="${var.y2}";;
                3)  x="${var.x3}" y="${var.y3}";;
                4)  x="${var.x4}" y="${var.y4}";;
                *)  x=0 y=$((1080 + ($1 - 4) * 100));;
            esac
        }

        event_openwindow() {
            case "$WINDOWCLASS" in
                mpv)
                    clients=$(hyprctl clients -j)
                    ((mpv_count++))
                    assign_coordinates "$mpv_count"

                    for ((i = 0; i < ''${#addresses[@]}; i++)); do
                        hide_others="dispatch setprop address:"0x''${addresses[$i]}" alphainactive ${var.low};"
                    done
                    addresses+=( "$WINDOWADDRESS" )

                    mpvplaycontrol "0x$WINDOWADDRESS" "$clients"
                    hyprctl --batch "$hide_others; dispatch movewindowpixel exact $x $y, address:0x$WINDOWADDRESS"
                    echo "mpv_$mpv_count=0x$WINDOWADDRESS" >> "$mpv_addresses_file"
                    ;;
            esac
        }

event_closewindow() {
    # Check if WINDOWADDRESS is in the array
    if [[ " ''${addresses[@]} " =~ " $WINDOWADDRESS " ]]; then
        # Find and remove the closed window's address from the array
        for i in "''${!addresses[@]}"; do
            if [[ "''${addresses[$i]}" == "$WINDOWADDRESS" ]]; then
                unset "addresses[$i]"
                addresses=("''${addresses[@]}")  # Re-index the array
                ((mpv_count--))
                break
            fi
        done

        # Handle cases based on the number of remaining addresses
        if [[ ''${#addresses[@]} -gt 0 ]]; then
            # Adjust window positions if there are remaining windows
            : > "$mpv_addresses_file"  # Clear the file
            output=()
            for ((i = 0; i < ''${#addresses[@]}; i++)); do
                assign_coordinates "$((i + 1))"
                output+=("mpv_$((i + 1))=0x''${addresses[$i]}")
                hyprctl dispatch movewindowpixel exact "$x $y", address:"0x''${addresses[$i]}"
            done
            printf "%s\n" "''${output[@]}" >> "$mpv_addresses_file"
        else
            # No addresses left, clear the file
            : > "$mpv_addresses_file"
        fi
    else
        return 1
    fi
}

        while true; do
          if read -r event_data; then
            event="''${event_data%%>>*}"
            edata="''${event_data#"$event">>}"

            IFS=','
            # shellcheck disable=SC2086 # splitting is intended
            set -- $edata
            IFS=$PFS

            if [ -n "$verbose" ]; then
              printf >&2 '[%s] 1:%s 2:%s 3:%s 4:%s\n' "$event" "$1" "$2" "$3" "$4"
            fi

            case "$event" in
            "openwindow") WINDOWADDRESS="$1" WORKSPACENAME="$2" WINDOWCLASS="$3" WINDOWTITLE="$4" event_openwindow ;;
            "closewindow") WINDOWADDRESS="$1" event_closewindow ;;
            *) ;;
            esac
          fi
        done
      '')
      (writeShellScriptBin "closeMpvWindow" ''
        set -e
        source /tmp/mpv_addresses

        # Match the appropriate mpv address based on the argument
        mpv_variable="mpv_$1"
        # Use indirect expansion to get the address dynamically
        target_address=''${!mpv_variable}

        # Check if target_address is empty
        if [[ -z "$target_address" ]]; then
            exit 1
        fi

        hyprctl dispatch closewindow address:$target_address
      '')
      (writeShellScriptBin "toggleFS" ''
        source /tmp/mpv_addresses

        mpv_socket_dir="/tmp/mpvSockets"
        mpvplaycontrol() {
            # Iterate through each mpv client
            while read -r address pid; do
                if [[ "$address" == "$target_address" ]]; then
                    target_pid=$pid
                else
                    echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
                    cmds+="dispatch setprop address:"$address" alphainactive ${var.low};"
                fi
            done <<< "$(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$clients")"
            if [[ -n "$target_pid" ]]; then
                hyprctl --batch $cmds dispatch setprop address:"$target_address" alphainactive ${var.high}
                # Toggle pause state (play if paused, pause if playing)
                sleep 0.1
                echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
            fi
        }

        # Match the appropriate mpv address based on the argument
        mpv_variable="mpv_$1" 
        target_address=''${!mpv_variable}
        [ -z "$target_address" ] && exit

        clients=$(hyprctl clients -j)
        monitors_json=$(hyprctl monitors -j)

        special_workspace=$(jq -r '.[] | .specialWorkspace.name' <<< "$monitors_json")
        active_workspace=$(jq -r '.[] | .activeWorkspace.name' <<< "$monitors_json")
        target_workspace=$(jq -r --arg addr "$target_address" '.[] | select(.address == $addr) | .workspace.name' <<< "$clients")

        [[ -n "$special_workspace" ]] && hyprctl dispatch togglespecialworkspace "$special_workspace"

        target_is_fullscreen=$(jq -r --arg addr "$target_address" '.[] | select(.address == $addr) | .fullscreen' <<< "$clients")
        last_focused=$(jq -r --arg ws "$target_workspace" '
            map(select((.workspace.name == $ws) and ( .class != "mpv"))) 
            | min_by(.focusHistoryID) 
            | .address' <<< "$clients")        
        another_fullscreen=$(jq -r --arg addr "$target_address" --arg ws "$target_workspace" \
          '.[] | select(.fullscreen == 2 and .address != $addr and .class == "mpv" and .workspace.name==$ws ) | .address' <<< "$clients")

        another_window=$(jq -r --arg addr "$target_address" --arg ws "$target_workspace" \
          '.[] | select(.address != $addr and .class == "mpv" and .workspace.name==$ws) | .address' <<< "$clients")

        # Handle fullscreen behavior
        if [[ "$target_is_fullscreen" == "2" ]]; then
            if [[ "$another_fullscreen" != "" ]]; then
                cmds+="dispatch focuswindow address:$target_address; dispatch fullscreen; dispatch setprop address:$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
            else
                if [[ "$active_workspace" != "$target_workspace" ]]; then 
                cmds+="dispatch focuswindow address:$target_address; dispatch fullscreen; dispatch setprop address:$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
                # If the target_address is already fullscreen, focus it and toggle fullscreen
                else
                cmds+="dispatch setprop address:$another_window nofocus 1; dispatch fullscreen; dispatch setprop address:$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
                fi
            fi
        else
            if [[ "$another_fullscreen" != "" ]]; then
                hyprctl dispatch setprop address:$another_fullscreen nofocus 1
            fi
                cmds+="setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch fullscreen;"
        fi
        mpvplaycontrol
      '')

      (writeShellScriptBin "togglePAUSE" ''
        source /tmp/mpv_addresses
        source ~/.config/hypr/scripts/variables.sh
        mpv_socket_dir="/tmp/mpvSockets"

        mpvplaycontrol() {
            clients=$(hyprctl clients -j)
            
            # Iterate through each mpv client
            while read -r address pid; do
                if [[ "$address" == "$1" ]]; then
                    target_pid="$pid"
                else
                    echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
                    cmds+="dispatch setprop address:"$address" alphainactive ${var.low};"
                fi
            done <<< "$(jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' <<< "$clients")"

            if [[ -n "$target_pid" ]]; then
                is_paused=$(echo '{"command":["get_property","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid" | jq -r '.data')
                [[ "$is_paused" == "true" ]] && opacity_value=${var.high} || opacity_value=${var.low}
                hyprctl --batch $cmds dispatch setprop address:"$1" alphainactive "$opacity_value"
                # Toggle pause state
                sleep 0.1
                echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
            fi
        }

        # Match the appropriate mpv address based on the argument
        mpv_variable="mpv_$1" 
        target_address=''${!mpv_variable}

        if [[ -z "$target_address" ]]; then
            exit 1
        fi

        mpvplaycontrol "$target_address"
        '')

        (writeShellScriptBin "fakehome" ''
         BIN=$1
          export HOME="''${HOME}/opt/$(basename "$BIN")"
          [ -d "$HOME" ] || mkdir -p "$HOME"
          # run
          ''${BIN}
          '')
    ];
  }
