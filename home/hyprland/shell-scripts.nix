{ pkgs, ... }: 
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

  set states (cat /tmp/mpv_states)

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
      # Update states
          set idx (contains -i "$address" $mpv_addresses)
          set states[$idx] "paused"
      end

      # Unpause target and set opacity
      echo '{"command":["set_property","pause",false]}' | socat - UNIX-CONNECT:"/tmp/mpvSockets/$target_pid" &

      set target_index (contains -i "$target_address" $mpv_addresses)
      if test -n "$target_index"
          set states[$target_index] "playing"
      end

      set -a cmds \
          "dispatch setprop address:$target_address nofocus 0" \
          "dispatch focuswindow address:$target_address" \
          "dispatch fullscreen"
  end
  printf "%s\n" $states > /tmp/mpv_states
  hyprctl --batch (string join ";" $cmds)
  '')

  (writers.writeFishBin "togglePAUSE" ''
    set mpv_socket_dir "/tmp/mpvSockets"
    set mpv_addresses (cat /tmp/mpv_addresses)
    set target_address $mpv_addresses[$argv[1]]

    function cycleState
      set clients (hyprctl clients -j)
      set target_pid (echo $clients | jq -r --arg addr $target_address '.[] | select(.class=="mpv" and .address==$addr) | .pid')

      test -z "$target_pid" && return

      echo '{"command":["cycle","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"

      set pause_state (echo '{"command":["get_property","pause"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid" | jq -r '.data')

      set states (cat /tmp/mpv_states)
      set target_index (contains -i "$target_address" $mpv_addresses)
      set states[$target_index] (test "$pause_state" = "false" && echo "playing" || echo "paused")

      if test "$pause_state" = "false"
        echo $clients | jq -r --arg target "$target_address" '
            .[] | select(.class=="mpv" and .address != $target) |
            (.pid|tostring) + " " + .address
        ' | while read -l pid address
            # Use the variables directly
            echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
            # Update states
            set idx (contains -i "$address" $mpv_addresses)
            set states[$idx] "paused"
        end
      end
      printf "%s\n" $states > /tmp/mpv_states
      hyprctl --batch (string join ";" $cmds)
    end

    if test -n "$target_address" -a (count $argv) -eq 1
      cycleState
    else 
      echo "Usage: togglePAUSE <instance-number>"
      exit 1
    end
    ''
  )

(writers.writeFishBin "mpvSeek" ''
  set mpv_socket_dir "/tmp/mpvSockets"
  set default_seek 10  # Default absolute value

  # Parse single argument
  set seek_cmd $default_seek
  if set -q argv[1]
    if string match -qr '^-?\d+$' -- $argv[1]
      set seek_cmd $argv[1]
    else
      echo "Error: Invalid seek value '$argv[1]' - must be integer"
      exit 1
    end
  end

  # Find playing window
  set addresses (cat /tmp/mpv_addresses)
  set states (cat /tmp/mpv_states)
  set playing_index (contains -i "playing" $states)
  if test -z "$playing_index"
    exit 1
  end

  # Get PID and execute seek
  set target_address $addresses[$playing_index]
  set target_pid (hyprctl clients -j | jq -r --arg addr "$target_address" '
    .[] | select(.address == $addr).pid')
  
  echo '{"command":["seek", '$seek_cmd', "relative"]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$target_pid"
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
  RCLONE_OPTS="--transfers 8 --checkers 16 -P \
  --retries 3 --retries-sleep 10s \
  --fast-list \
  --timeout 300s --contimeout 60s \
  --log-level INFO"

  cd ~
  rclone $RCLONE_OPTS sync Documents mega:Documents
  rclone $RCLONE_OPTS sync MediaHub mega:MediaHub
  rclone $RCLONE_OPTS sync MathCareer mega:MathCareer
  rclone $RCLONE_OPTS sync Music mega:Music
'')
];
}
