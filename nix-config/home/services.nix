{pkgs, ...}:

{
  home.stateVersion = "24.11";
  home.sessionPath = [
    "$HOME/bin"
  ];
  xdg.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "/home/edwin/Music/2024/";
    extraConfig = ''
        auto_update "yes"
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
    '';
  };

  services.mpd-mpris = {
    enable = true;
  };

  services.fnott = {
  enable = true;
  settings = {
      main = {
          max-width = 300;
          default-timeout = 10;
          idle-timeout = 300;
          summary-font = "JetBrainsMono Nerd Font:weight=bold:size=12";
          body-font = "JetBrainsMono Nerd Font:size=11";
          layer = "overlay";
          progress-bar-height = 5;
          padding-vertical = 5;
          padding-horizontal = 10;
          edge-margin-vertical = 24;
          edge-margin-horizontal = 24;
          background = "111111FF";
          border-color = "888888FF";
          summary-format = "%s";
          body-format = "%b";
          title-format = "";
          play-sound = "paplay --volume=35000 \${filename}";
      };
  };
  };

  systemd.user.services.shellevents = let hyprevents = 
  let var = import ./variables.nix;
  in pkgs.writeShellScript "shellevents" ''
        PFS=$IFS
        verbose=
        case "$1" in
        -v) verbose=1 && shift ;;
        esac

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
      '';
    in {
    Unit.Description = "Hyprland Event Listener for shellevents";
    Service.ExecStart = ''
      /bin/sh -c '${pkgs.socat}/bin/socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock EXEC:'${hyprevents}',nofork'
      '';
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
