{pkgs, ...}:
{
  systemd.user.services.shellevents = let hyprevents = 
  let var = import ./variables.nix;
  in pkgs.writers.writeFish "shellevents" ''
    set mpv_socket_dir "/tmp/mpvSockets"
    set mpv_addresses_file "/tmp/mpv_addresses"
    set mpv_titles_file "/tmp/mpv_titles"
    set mpv_states_file "/tmp/mpv_states"
    set -g mpv_addresses
    set -g mpv_titles
    set -g mpv_states

    function cycle_pause
        hyprctl clients -j | jq -r --arg target "0x$WINDOWADDRESS" '
            .[] | select(.class=="mpv" and .address != $target) |
            (.pid|tostring) + " " + .address
        ' | while read -l pid address
            set idx (contains -i "$address" $mpv_addresses)
            set mpv_states[$idx] "paused"
            echo '{"command":["set_property","pause",true]}' | socat - UNIX-CONNECT:"$mpv_socket_dir/$pid" &
            set -ga cmds "dispatch setprop address:$address alphainactive ${var.low}"
        end
    end

    function format_title
        string replace -r ' - mpv$' "" "$argv[1]" |
        string replace '_' ' ' |  # Underscores to spaces
        string trim |                        # Remove whitespace
        string replace -r '(.{24}).+' '$1…'  # Truncate and add ellipsis
    end

    function update_files
        printf "%s\n" $mpv_addresses > $mpv_addresses_file
        printf "%s\n" $mpv_states > $mpv_states_file
        printf "%s\n" $mpv_titles > $mpv_titles_file
    end

    function event_openwindow
        test "$WINDOWCLASS" = "mpv" || return
        set -a mpv_addresses "0x$WINDOWADDRESS"

        set idx (contains -i "0x$WINDOWADDRESS" $mpv_addresses)
        if test $idx -eq 4
          hyprctl dispatch closewindow address:0x$WINDOWADDRESS
          return
        end

        set mpv_titles[$idx] (format_title "$WINDOWTITLE")
        set mpv_states[$idx] "playing"

        set -g cmds
        test (count $mpv_addresses) -gt 1 && cycle_pause

        set -a cmds "dispatch movewindowpixel exact ${var.x} ${var.y}, address:0x$WINDOWADDRESS"

        set batch_cmd (string join ";" $cmds)
        hyprctl --batch "$batch_cmd"
        update_files
        end

    function event_closewindow
        set idx (contains -i "0x$WINDOWADDRESS" $mpv_addresses)
        test -n "$idx" || return 1
        set mpv_states (cat $mpv_states_file)
        set -e mpv_addresses[$idx] mpv_titles[$idx] mpv_states[$idx]

        update_files
    end

    function event_windowtitlev2
        set idx (contains -i "0x$WINDOWADDRESS" $mpv_addresses)
        test -n "$idx" || return 1
        test -n "$WINDOWTITLE" || return  # New: Skip empty titles!

        set mpv_titles[$idx] (format_title "$WINDOWTITLE")
        printf "%s\n" $mpv_titles > $mpv_titles_file
    end

    while read event_data
        set event (string split ">>" "$event_data")[1]
        set fields (string split -- "," (string split -- ">>" "$event_data")[2])

        switch $event
            case "openwindow"
                set WINDOWADDRESS $fields[1]
                set WORKSPACENAME $fields[2]
                set WINDOWCLASS $fields[3]
                set WINDOWTITLE $fields[4]
                event_openwindow
            case "closewindow"
                set WINDOWADDRESS $fields[1]
                event_closewindow
            case "windowtitlev2"
                set WINDOWADDRESS $fields[1]
                set WINDOWTITLE $fields[2]
                event_windowtitlev2
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
