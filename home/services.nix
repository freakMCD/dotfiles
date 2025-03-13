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
            max-width = 380;
            max-height = 600;
            default-timeout = 8;
            idle-timeout = 240;
            layer = "overlay";
            padding-vertical = 20;
            padding-horizontal = 20;
            edge-margin-vertical = 30;
            edge-margin-horizontal = 10;
            dpi-aware="yes";

            # Fonts
            summary-font = "JetBrainsMono Nerd Font:weight=bold:size=13";
            body-font = "JetBrainsMono Nerd Font:size=12";
            title-font = "JetBrainsMono Nerd Font:size=14";

            # Colors
            background = "${config.colors.bg1}ee";
            summary-color = "${config.colors.yellow}ff";
            body-color = "${config.colors.white}dd";
            border-color = "${config.colors.bg3}66";
            border-size = 2;
            border-radius = 6;

            # Progress bar customization
            progress-bar-color = "${config.colors.yellow}cc";
            progress-bar-height = 8;

            # Text formatting
            title-format = "";  # No title formatting
            summary-format = "<b><i>%s</i></b>";  # Summary text
            body-format = "%b";  # Underlined action indicator
        };

        # Urgency-specific overrides
        low = {
          background = "${config.colors.bg2}ee";
          title-color = "${config.colors.gray}ff";
          summary-color = "${config.colors.gray}ff";
          body-color = "${config.colors.gray}dd";
          progress-bar-color = "${config.colors.gray}66";
        };

        critical = {
          background = "${config.colors.red}22";  # Subtle red overlay
          border-color = "${config.colors.red}ff";
          title-color = "${config.colors.red}ff";
          summary-color = "${config.colors.yellow}ff";
          border-size = 2;
          progress-bar-color = "${config.colors.red}ff";
        };
      };
    };

  systemd.user.services.shellevents = let hyprevents = 
  let var = import ./variables.nix;
  in pkgs.writers.writeFish "shellevents" ''
    set mpv_socket_dir "/tmp/mpvSockets"
    set mpv_addresses_file "/tmp/mpv_addresses"
    set mpv_count_file "/tmp/mpv_count"
    set mpv_addresses
    set mpv_count 0

    function cycle_pause
      hyprctl clients -j | jq -r --arg target "0x$WINDOWADDRESS" '
          .[] | select(.class=="mpv" and .address != $target) |
          (.pid|tostring) + " " + .address
      ' | while read -l pid address
          # Use the variables directly
          echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
          set cmds "dispatch setprop address:$address alphainactive ${var.low};"
      end
    end

    function event_openwindow
        set -g cmds
        test "$WINDOWCLASS" = "mpv" || return
        notify-send "$WINDOWTITLE"
        set mpv_count (math $mpv_count + 1)
        set -a mpv_addresses "$WINDOWADDRESS"

        test $mpv_count -gt 1 && cycle_pause
        hyprctl --batch "$cmds dispatch movewindowpixel exact ${var.x} ${var.y}, address:0x$WINDOWADDRESS"
        echo "0x$WINDOWADDRESS" >> "$mpv_addresses_file"
        echo "$mpv_count" > $mpv_count_file
    end

    function event_closewindow
      set index (contains -i $WINDOWADDRESS $mpv_addresses)
      test -n "$index" || return 1

      set -e mpv_addresses[$index]
      set mpv_count (math $mpv_count - 1)
      echo $mpv_count > $mpv_count_file

      printf "" > $mpv_addresses_file
      for i in (seq $mpv_count)
        echo "0x$mpv_addresses[$i]" >> $mpv_addresses_file
        hyprctl dispatch movewindowpixel exact "${var.x} ${var.y}", address:"0x$mpv_addresses[$i]"
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
            case "openwindow"; event_openwindow
            case "closewindow"; event_closewindow
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
