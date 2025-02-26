{pkgs, ...}:

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
  in pkgs.writers.writeFish "shellevents" ''
    set mpv_socket_dir "/tmp/mpvSockets"
    set mpv_addresses_file "/tmp/mpv_addresses"
    set addresses
    set mpv_count 0

    function cycleMute
      set clients_json (hyprctl clients -j)
      set target_pid (echo $clients_json | jq -r --arg addr "0x$WINDOWADDRESS" '.[] | select(.class=="mpv" and .address==$addr) | .pid')

      if test -n "$target_pid"
         for pid in (echo $clients_json | jq -r --arg target "0x$WINDOWADDRESS" '.[] | select(.class=="mpv" and .address != $target) | .pid')
           echo '{"command":["set_property","mute",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid"
         end
      end
    end

    function event_openwindow
        if test "$WINDOWCLASS" = "mpv"
            set mpv_count (math $mpv_count + 1)

            switch $mpv_count
                case 1; set x ${var.x1}; set y ${var.y1}
                case 2; set x ${var.x2}; set y ${var.y2}
                case 3; set x ${var.x3}; set y ${var.y3}
                case 4; set x ${var.x4}; set y ${var.y4}
                case '*'; set x 0; set y (math "1080 + ($argv[1] - 4) * 100")
            end

            set -a addresses "$WINDOWADDRESS"

            hyprctl --batch "dispatch movewindowpixel exact $x $y, address:0x$WINDOWADDRESS"
            echo "set mpv$mpv_count 0x$WINDOWADDRESS" >> "$mpv_addresses_file"
            cycleMute
        end
    end

    function event_closewindow
        if contains $WINDOWADDRESS $addresses
            for addr in $addresses
                if test $addr != $WINDOWADDRESS
                    set -a new_addresses $addr
                end
            end
            set addresses $new_addresses
            set mpv_count (math $mpv_count - 1)

            echo -n "" > $mpv_addresses_file
            if test (count $addresses) -gt 0
                set output
                for i in (seq (count $addresses))
                  switch (math "$i")
                      case 1; set x ${var.x1}; set y ${var.y1}
                      case 2; set x ${var.x2}; set y ${var.y2}
                      case 3; set x ${var.x3}; set y ${var.y3}
                      case 4; set x ${var.x4}; set y ${var.y4}
             case '*'; set x 0; set y (math "1080 + ($argv[1] - 4) * 100")
                  end
                  echo "set mpv$i 0x$addresses[$i]" >> $mpv_addresses_file
                  hyprctl dispatch movewindowpixel exact "$x $y", address:"0x$addresses[$i]"
                end
            end
        else
            return 1
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
