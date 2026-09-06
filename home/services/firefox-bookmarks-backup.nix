{ config, pkgs, ... }:

{
  systemd.user.services.firefox-bookmarks-backup = {
    Unit.Description = "Back up Firefox bookmarks to Google Drive";

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone copy \
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
