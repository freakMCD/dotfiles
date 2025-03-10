{ pkgs, ... }: 
let
var = import ./variables.nix;
in
{
  home.packages = with pkgs; [
    jq socat
(writers.writeFishBin "closeMpvWindow" ''
  set mpv_addresses (cat /tmp/mpv_addresses)
  set target_address $mpv_addresses[$argv[1]]
  
  test -n "$target_address" || return
  hyprctl dispatch closewindow address:$target_address
  ''
)

(writers.writeFishBin "toggleFS" ''
  set mpv_socket_dir "/tmp/mpvSockets"
  set mpv_addresses (cat /tmp/mpv_addresses)
  set target_address $mpv_addresses[$argv[1]]

  test -z $target_address && exit 1

  set clients (hyprctl clients -j)
  set monitor_json (hyprctl monitors -j)

  # Extract target MPV info
  set target_info (echo $clients | jq --arg addr $target_address '
      .[] | select(.class == "mpv" and .address == $addr) | {
          fullscreen,
          pid,
          workspace: .workspace.name
      }')

  # Parse extracted client data
  set target_ws (echo $target_info | jq -r '.workspace')
  set target_pid (echo $target_info | jq -r '.pid')
  set is_fullscreen (echo $target_info | jq -r '.fullscreen == 2')

  # Monitor states
  set special_ws (echo $monitor_json | jq -r '.[].specialWorkspace.name')
  test -z "$special_ws" || hyprctl dispatch togglespecialworkspace "$special_ws"
      
  # Build command string based on fullscreen state
  set cmds ""
  if test "$is_fullscreen" = "true"
      # Exit fullscreen
      set last_focused (echo $clients | jq -r --arg ws $target_ws '
          [.[] | select(.workspace.name == $ws and .class != "mpv")]
          | min_by(.focusHistoryID).address')
      set cmds \
          "dispatch focuswindow address:$target_address" \
          "dispatch fullscreen" \
          "dispatch setprop address:$target_address nofocus 1" \
          "dispatch focuswindow address:$last_focused"
  else
      # Enter fullscreen
      echo $clients | jq -r --arg target "$target_address" '
          .[] | select(.class == "mpv" and .address != $target) |
          (.pid | tostring) + " " + .address + " " + (.fullscreen | tostring)
      ' | while read -l pid address fullscreen
          # Reset previous fullscreen MPVs
          if test "$fullscreen" = "2"
              set -a cmds "dispatch setprop address:$address nofocus 1"
          end
          echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
          set -a cmds "dispatch setprop address:$address alphainactive ${var.low}"
      end

      # Unpause target and set opacity
      echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"/tmp/mpvSockets/$target_pid" &

      set -a cmds \
          "dispatch setprop address:$target_address alphainactive ${var.high}" \
          "dispatch setprop address:$target_address nofocus 0" \
          "dispatch focuswindow address:$target_address" \
          "dispatch fullscreen"
  end

  hyprctl --batch (string join ";" $cmds)
  '')

  (writers.writeFishBin "togglePAUSE" ''
    set mpv_socket_dir "/tmp/mpvSockets"

    function cycleState
      set clients (hyprctl clients -j)
      set target_pid (echo $clients | jq -r --arg addr "$target_address" '.[] | select(.class=="mpv" and .address==$addr) | .pid')

      test -z "$target_pid" && return

      echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"

      set pause_state (echo '{"command":["get_property","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid" | jq -r '.data')
      set alpha (test "$pause_state" = "false" && echo ${var.high} || echo ${var.low})
      set cmds "dispatch setprop address:$target_address alphainactive $alpha"

      if test "$pause_state" = "false"
        echo $clients | jq -r --arg target "$target_address" '
            .[] | select(.class=="mpv" and .address != $target) |
            (.pid|tostring) + " " + .address
        ' | while read -l pid address
            # Use the variables directly
            echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
            set -a cmds "dispatch setprop address:$address alphainactive ${var.low}"
        end
      end
      hyprctl --batch (string join ";" $cmds)
    end

    set mpv_addresses (cat /tmp/mpv_addresses)
    set target_address $mpv_addresses[$argv[1]]

    if test -n "$target_address" -a (count $argv) -eq 1
      cycleState
    else 
      echo "Usage: togglePAUSE <instance-number>"
      exit 1
    end
    ''
  )

(writers.writeFishBin "toggleVIEW" ''
    # State file to track current opacity
    set state_file "/tmp/hypr_opacity_state"
    
    # Determine target opacity
    if test -e "$state_file" && grep -q "high" "$state_file"
        set target_opacity ${var.low}
        set new_state "low"
    else
        set target_opacity ${var.high}
        set new_state "high"
    end

    set clients (hyprctl clients -j)

    # Apply to all mpv windows
    echo $clients | jq -r '.[] | select(.class=="mpv" ) | .address' | while read -l address
        set -a cmds "dispatch setprop address:$address alphainactive $target_opacity"
    end

    # Execute commands and update state
    hyprctl --batch (string join ";" $cmds)
    echo "$new_state" > "$state_file"
'')

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
