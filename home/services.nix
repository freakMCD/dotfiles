{pkgs, lib, config, ...}:

{
  home.username = "edwin";
  home.homeDirectory = "/home/edwin/";
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
            # Layout and sizing
            max-width = 350;
            max-height = 500;
            default-timeout = 10;
            idle-timeout = 300;
            layer = "overlay";
            progress-bar-height = 5;
            padding-vertical = 12;
            padding-horizontal = 12;
            edge-margin-vertical = 24;
            edge-margin-horizontal = 24;
            # Fonts
            summary-font = "JetBrainsMono Nerd Font:weight=bold:size=15";
            body-font = "JetBrainsMono Nerd Font:size=13";
            title-font = "JetBrainsMono Nerd Font:size=14";
            # Colors
            background = "${config.colors.bg1}ff";
            title-color = "${config.colors.yellow}ff";
            summary-color = "${config.colors.blue}ff";
            body-color = "${config.colors.white}ff";
            border-color = "${config.colors.bg3}ff";
            border-size = 2;
            # Progress bar customization
            progress-bar-color = "${config.colors.blue}ff";
            # Text formatting
            title-format = "";  # No title formatting
            summary-format = "%b";  # Summary text
            body-format = "%b";  # Body text
            # Additional aesthetic improvements
            border-radius = 8;
        };
    };
  };

  systemd.user.services.shellevents = let hyprevents = 
  let var = import ./variables.nix;
  in pkgs.writers.writeFish "shellevents" ''
    set mpv_socket_dir "/tmp/mpvSockets"
    set mpv_addresses_file "/tmp/mpv_addresses"
    set mpv_addresses
    set mpv_count 0
    set -g cmds

    set -g x_coords ${lib.concatStringsSep " " (map (i: var."x${toString i}") (lib.range 1 9))}
    set -g y_coords ${lib.concatStringsSep " " (map (i: var."y${toString i}") (lib.range 1 9))}

    function cycle_pause
      hyprctl clients -j | jq -r --arg target "0x$WINDOWADDRESS" '
          .[] | select(.class=="mpv" and .address != $target) |
          (.pid|tostring) + " " + .address
      ' | while read -l pid address
          # Use the variables directly
          echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
          set -a cmds "dispatch setprop address:$address alphainactive ${var.low};"
      end
    end

    function event_openwindow
        test "$WINDOWCLASS" = "mpv" || return
        set mpv_count (math $mpv_count + 1)
        set -a mpv_addresses "$WINDOWADDRESS"

        test $mpv_count -gt 1 && cycle_pause

        hyprctl --batch "$cmds dispatch movewindowpixel exact $x_coords[$mpv_count] $y_coords[$mpv_count], address:0x$WINDOWADDRESS"
        echo "0x$WINDOWADDRESS" >> "$mpv_addresses_file"
    end

    function event_closewindow
      set index (contains -i $WINDOWADDRESS $mpv_addresses)
      test -n "$index" || return 1

      set -e mpv_addresses[$index]
      set mpv_count (math $mpv_count - 1)

      printf "" > $mpv_addresses_file
      for i in (seq $mpv_count)
        echo "0x$mpv_addresses[$i]" >> $mpv_addresses_file
        hyprctl dispatch movewindowpixel exact "$x_coords[$i] $y_coords[$i]", address:"0x$mpv_addresses[$i]"
      end
    end

    while read event_data
        set event (string split ">>" "$event_data")[1]
        set fields (string split -- "," (string split -- ">>" "$event_data")[2])

        set WINDOWADDRESS $fields[1]
        set WORKSPACENAME $fields[2]
        set WINDOWCLASS $fields[3]
        set WINDOWTITLE $fields[4]

        switch $event
            case "openwindow"; event_openwindow; echo "$event $fields"
            case "closewindow"; event_closewindow; echo "$event $fields"
        end
    end
      '';
    in {
    Unit.Description = "Hyprland Event Listener for shellevents";
    Service.ExecStart = ''
      /bin/sh -c '${pkgs.socat}/bin/socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock EXEC:'${hyprevents}',nofork'
      '';
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
