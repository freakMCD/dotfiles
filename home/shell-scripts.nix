{ pkgs, ... }: 
let
var = import ./variables.nix;
in
{
  home.packages = with pkgs; [
    jq socat
  (writers.writeFishBin "closeMpvWindow" ''
    source /tmp/mpv_addresses
    set target_address "mpv$argv[1]"
    
    if test -n "$$target_address"
      hyprctl dispatch closewindow address:$$target_address
    end
    ''
  )

  (writers.writeFishBin "toggleFS" ''
    source /tmp/mpv_addresses
    set mpv_socket_dir "/tmp/mpvSockets"
    set name_target "mpv$argv[1]" 

    set target_address $$name_target
    if test -z $target_address
      exit 1
    end

    set clients (hyprctl clients -j)
    set monitors_json (hyprctl monitors -j)
  
      function cyclePause
        set target_pid (echo $clients | jq -r --arg addr "$target_address" '.[] | select(.class=="mpv" and .address==$addr) | .pid')
        if test -n "$target_pid"
          echo '{"command":["set_property","pause",false]}'\n'{"command":["set_property","mute",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"

            for pid in (echo $clients | jq -r --arg target "$target_address" '.[] | select(.class=="mpv" and .address != $target) | .pid')
              echo '{"command":["set_property","mute",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
            end
        end
      end

    # Extract workspace details from monitors JSON
    set active_workspace (echo $monitors_json | jq -r '.[].activeWorkspace.name')
    set target_workspace (echo $clients | jq -r --arg addr "$target_address" '
        .[] | select(.address == $addr) | .workspace.name')
    set special_workspace (echo $monitors_json | jq -r '.[].specialWorkspace.name')
    if test -n "$special_workspace"
        hyprctl dispatch togglespecialworkspace "$special_workspace"
    end
    
    # Extract fullscreen and focus-related values from clients JSON
    set target_is_fullscreen (echo $clients | jq -r --arg addr "$target_address" '
        .[] | select(.address == $addr) | .fullscreen')
    set last_focused (echo $clients | jq -r --arg ws "$target_workspace" '
        map(select((.workspace.name == $ws) and (.class != "mpv"))) 
        | min_by(.focusHistoryID) 
        | .address')
    set another_fullscreen (echo $clients | jq -r --arg addr "$target_address" --arg ws "$target_workspace" '
        .[] | select(.fullscreen == 2 and .address != $addr and .class == "mpv" and .workspace.name == $ws) | .address')
    set another_window (echo $clients | jq -r --arg addr "$target_address" --arg ws "$target_workspace" '
        .[] | select(.address != $addr and .class == "mpv" and .workspace.name == $ws) | .address')
    
    # Build command string based on fullscreen state
    set cmds ""
    if test "$target_is_fullscreen" = "2"
        # Combine conditions since both branches issue the same command string
        if test -n "$another_fullscreen" -o "$active_workspace" != "$target_workspace"
            set cmds "$cmds dispatch focuswindow address:$target_address; dispatch fullscreen; dispatch setprop address:$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
        else
            set cmds "$cmds dispatch setprop address:$another_window nofocus 1; dispatch fullscreen; dispatch setprop address:$target_address nofocus 1; dispatch focuswindow address:$last_focused;"
        end
    else
        if test -n "$another_fullscreen"
            hyprctl dispatch setprop address:$another_fullscreen nofocus 1
        end
        set cmds "$cmds dispatch setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch fullscreen;"
        cyclePause
    end
    hyprctl --batch "$cmds"
    '')

    (writers.writeFishBin "toggleSTATE" ''
      source /tmp/mpv_addresses
      set mpv_socket_dir "/tmp/mpvSockets"

      function cycleState
        set clients_json (hyprctl clients -j)
        set target_pid (echo $clients_json | jq -r --arg addr "$target_address" '.[] | select(.class=="mpv" and .address==$addr) | .pid')

        if test -n "$target_pid"
          switch $state
            case pause
              echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"

            case mute
              echo '{"command":["cycle","mute"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
              sleep 0.1
              # If the target was muted (now is unmuted), adjust mutes.
              set pause_state (echo '{"command":["get_property","mute"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid" | jq -r '.data')
              if test "$pause_state" = "false"
                  for pid in (echo $clients_json | jq -r --arg target "$target_address" '.[] | select(.class=="mpv" and .address != $target) | .pid')
                    echo '{"command":["set_property","mute",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
                  end
              end
            case '*'
              echo "unknown state :$state"
          end
        end
      end

      set name_target "mpv$argv[2]" 
      set target_address $$name_target

      if test -n "$target_address" -a (count $argv) -ge 2
        set state $argv[1]
        cycleState
      else 
        echo "Usage: unified_mpv_control <instance-number> <pause|mute>"
        exit 1
      end
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
