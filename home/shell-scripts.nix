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
    
    test -n "$$target_address" || return
    hyprctl dispatch closewindow address:$$target_address
    ''
  )

  (writers.writeFishBin "toggleFS" ''
    source /tmp/mpv_addresses
    set mpv_socket_dir "/tmp/mpvSockets"
    set name_target "mpv$argv[1]" 
    set target_address $$name_target

    test -z $target_address && exit 1

    set clients (hyprctl clients -j)
    set monitors_json (hyprctl monitors -j)
  
      function cyclePause
        set target_pid (echo $clients | jq -r --arg addr "$target_address" '.[] | select(.class=="mpv" and .address==$addr) | .pid')

        test -z "$target_pid" && return

        echo '{"command":["set_property","pause",false]}'\n'{"command":["set_property","mute",false]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
        set -a cmds "dispatch setprop address:$target_address alphainactive ${var.high};"

          echo $clients | jq -r --arg target "$target_address" '
              .[] | select(.class=="mpv" and .address != $target) |
              (.pid|tostring) + " " + .address
          ' | while read -l pid address
              # Use the variables directly
              echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
              set -a cmds "dispatch setprop address:$address alphainactive ${var.low};"
          end
      end

    # Extract workspace details from monitors JSON
    set active_workspace (echo $monitors_json | jq -r '.[].activeWorkspace.name')
    set target_workspace (echo $clients | jq -r --arg addr "$target_address" '
        .[] | select(.address == $addr) | .workspace.name')
    set special_workspace (echo $monitors_json | jq -r '.[].specialWorkspace.name')
    test -z "$special_workspace" || hyprctl dispatch togglespecialworkspace "$special_workspace"
    
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
        test -n "$another_fullscreen" && hyprctl dispatch setprop address:$another_fullscreen nofocus 1
        cyclePause
        set cmds "$cmds dispatch setprop address:$target_address nofocus 0; dispatch focuswindow address:$target_address; dispatch fullscreen;"
    end
    hyprctl --batch "$cmds"
    '')

    (writers.writeFishBin "togglePAUSE" ''
      source /tmp/mpv_addresses
      set mpv_socket_dir "/tmp/mpvSockets"

      function cycleState
        set clients (hyprctl clients -j)
        set target_pid (echo $clients | jq -r --arg addr "$target_address" '.[] | select(.class=="mpv" and .address==$addr) | .pid')

        test -z "$target_pid" && return

        echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
        sleep 0.1

        set pause_state (echo '{"command":["get_property","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid" | jq -r '.data')
        set alpha (test "$pause_state" = "false" && echo ${var.high} || echo ${var.low})
        set -a cmds "dispatch setprop address:$target_address alphainactive $alpha;"

        if test "$pause_state" = "false"
          echo $clients | jq -r --arg target "$target_address" '
              .[] | select(.class=="mpv" and .address != $target) |
              (.pid|tostring) + " " + .address
          ' | while read -l pid address
              # Use the variables directly
              echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
              set -a cmds "dispatch setprop address:$address alphainactive ${var.low};"
          end
        end
        hyprctl --batch "$cmds"
      end

      set name_target "mpv$argv[1]" 
      set target_address $$name_target

      if test -n "$target_address" -a (count $argv) -eq 1
        cycleState
      else 
        echo "Usage: togglePAUSE <instance-number>"
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
