{ pkgs, ... }: 
let
var = import ./variables.nix;
in
{
  home.packages = with pkgs; [
    jq socat
  (writers.writeFishBin "closeMpvWindow" /* fish */ ''
    source /tmp/mpv_addresses
    set target_address "mpv$argv[1]"
    
    if test -z "$target_address"
        exit 1
    end

    hyprctl dispatch closewindow address:$$target_address
    ''
  )

  (writers.writeFishBin "toggleFS" /* fish */ ''
    set fish_trace 1
    source /tmp/mpv_addresses
    set target_address "mpv$argv[1]"
    set mpv_socket_dir "/tmp/mpvSockets"
    
    # Cache JSON outputs from hyprctl
    set clients (hyprctl clients -j)
    set monitors_json (hyprctl monitors -j)
    
    # Extract workspace details from monitors JSON
    set active_workspace (echo $monitors_json | jq -r '.[].activeWorkspace.name')
    set target_workspace (echo $clients | jq -r --arg addr "$$target_address" '
        .[] | select(.address == $addr) | .workspace.name')
    set special_workspace (echo $monitors_json | jq -r '.[].specialWorkspace.name')
    if test -n "$special_workspace"
        hyprctl dispatch togglespecialworkspace "$special_workspace"
    end
    
    # Extract fullscreen and focus-related values from clients JSON
    set target_is_fullscreen (echo $clients | jq -r --arg addr "$$target_address" '
        .[] | select(.address == $addr) | .fullscreen')
    set last_focused (echo $clients | jq -r --arg ws "$target_workspace" '
        map(select((.workspace.name == $ws) and (.class != "mpv"))) 
        | min_by(.focusHistoryID) 
        | .address')
    set another_fullscreen (echo $clients | jq -r --arg addr "$$target_address" --arg ws "$target_workspace" '
        .[] | select(.fullscreen == 2 and .address != $addr and .class == "mpv" and .workspace.name == $ws) | .address')
    set another_window (echo $clients | jq -r --arg addr "$$target_address" --arg ws "$target_workspace" '
        .[] | select(.address != $addr and .class == "mpv" and .workspace.name == $ws) | .address')
    
    # Build command string based on fullscreen state
    set cmds ""
    if test "$target_is_fullscreen" = "2"
        # Combine conditions since both branches issue the same command string
        if test -n "$another_fullscreen" -o "$active_workspace" != "$target_workspace"
            set cmds "$cmds dispatch focuswindow address:$$target_address; dispatch fullscreen; dispatch setprop address:$$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
        else
            set cmds "$cmds dispatch setprop address:$another_window nofocus 1; dispatch fullscreen; dispatch setprop address:$$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
        end
    else
        if test -n "$another_fullscreen"
            hyprctl dispatch setprop address:$another_fullscreen nofocus 1
        end
        set cmds "$cmds dispatch setprop address:$$target_address nofocus 0; dispatch focuswindow address:$$target_address; dispatch fullscreen;"
    end
    
    function mpvplaycontrol
        echo $argv | jq -r '.[] | select(.class == "mpv") | "\(.address) \(.pid)"' | while read -l address pid
            if test "$address" = "$$target_address"
                set target_pid $pid
            else
                echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
            end
        end
        if test -n "$target_pid"
            hyprctl --batch "$cmds"
            # Toggle pause state (play if paused, pause if playing)
            sleep 0.1
            echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
        end
    end
    
    mpvplaycontrol $clients
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
      ''
    )

    (writeShellScriptBin "fakehome" ''
     BIN=$1
      export HOME="''${HOME}/.opt/$(basename "$BIN")"
      [ -d "$HOME" ] || mkdir -p "$HOME"
      # run
      ''${BIN}
    '')

    (writeShellScriptBin "open_file" ''
      selected_file=$(fzf --delimiter / --with-nth 4..)

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
  ];
}
