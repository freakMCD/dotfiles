{ config, pkgs, ... }:

{
  systemd.user.services.firefox-bookmarks-backup = {
    Unit.Description = "Back up Firefox bookmarks to Google Drive";

    Service = {
      Type = "oneshot";

      ExecStart = pkgs.writeShellScript "firefox-bookmarks-backup" ''
        set -eu

        iface="enp34s0"

        # Require >= 100 Mb/s for 10 consecutive seconds.
        stable=0

        while (( stable < 10 )); do
          speed="$(
            cat "/sys/class/net/$iface/speed" 2>/dev/null || echo 0
          )"

          if [[ "$speed" =~ ^[0-9]+$ ]] && (( speed >= 100 )); then
            (( stable += 1 ))
          else
            stable=0
          fi

          sleep 1
        done

        exec ${pkgs.rclone}/bin/rclone copy \
          ${config.home.homeDirectory}/.config/mozilla/firefox/default/bookmarkbackups \
          drive:Backups/Firefox-bookmarks \
          --retries 3
      '';
    };
  };

  systemd.user.timers.firefox-bookmarks-backup = {
    Unit.Description = "Daily Firefox bookmarks backup";

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
