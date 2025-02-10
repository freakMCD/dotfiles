{ pkgs, ... }: 
let
var = import ./variables.nix;
in
{
    home.packages = with pkgs; [
      jq socat
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

        (writeShellScriptBin "open_file" ''
          selected_file=$(fzf)

          # Open the selected file using nohup and redirect output to nohup.out
          nohup xdg-open "$selected_file" >/dev/null 2>&1 &
          sleep 0.2
          # Close the terminal
          exit 
        '')
        (writeShellScriptBin "syncMega" ''
          RCLONE_OPTS="--transfers 45 --checkers 65 -P"
          cd ~
          rclone $RCLONE_OPTS sync Documents mega:Documents
          rclone $RCLONE_OPTS sync MediaHub mega:MediaHub
          rclone $RCLONE_OPTS sync MathCareer mega:MathCareer
          rclone $RCLONE_OPTS sync Music mega:Music
        '')
        (writeShellScriptBin "updmusic" ''
          trap "echo 'Script interrupted. Exiting...'; exit" SIGINT

          # Define directories
          dir=~/Music/2024
          cd ~/Music
          mkdir -p "$dir"

          declare -A chill=(
              ["https://www.youtube.com/playlist?list=PL4CmunqMOJjKi1Mtlc3N5pedFJ5UgFobk"]="The Hall"
              ["https://www.youtube.com/playlist?list=PL4CmunqMOJjIkStqqrywj_o2whWaO9uRQ"]="Echo\: 2"
              ["https://www.youtube.com/playlist?list=PLf07F-mOry4_rJPuq0Km1I78Q6HMCujMO"]="Reol"
              ["https://www.youtube.com/playlist?list=PLz6DOTcCHlPCqi3MXe0Qlu-IeMPmymss2"]="Ado"
              ["https://www.youtube.com/playlist?list=PL1JxBieKp06LBAiOlziByhHyRwfMOLbDj"]="Babymetal"
              ["https://www.youtube.com/playlist?list=PLNv9SARzk_JYaL6MXCJym1PvtCWlaexcw"]="Fujii Kaze"
              ["https://www.youtube.com/playlist?list=PLBkOG5FFNCKwuqigmVPE_DrrdKKgEHpsZ"]="Sound Horizon"
              ["https://www.youtube.com/playlist?list=PLAsdGJurTv1DnTJwZAXc3Ct1C1Hgexari"]="IU"
              ["https://www.youtube.com/playlist?list=PLGhOCcpfhWjcakpbHXzej5KUYm-DH8vWk"]="IU Covers"
              ["https://www.youtube.com/playlist?list=PL4CmunqMOJjLJngQzRR6tExqelkRKa0Vc"]="Classics"
          )

          download_playlists() {
              declare -n playlists="$1"

              for url in "''${!playlists[@]}"; do
                  artist="''${playlists[$url]}"
                  filter="duration > 120 & duration < 600"

              echo -e "\e[1;32mDownloading $artist's playlist...\e[0m"

              yt-dlp --quiet --progress --parse-metadata " $artist:%(meta_artist)s" --match-filters "$filter & title!~='(?i)\blive\b'" \
                     -o "$dir/%(title)s_%(id)s.%(ext)s" "$url"
          done
          }
          download_playlists chill
          ''
        )
    ];
  }
