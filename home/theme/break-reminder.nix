{ pkgs, ... }:

let
  breakReminder = pkgs.writeShellScript "break-reminder" ''
    minute="$(${pkgs.coreutils}/bin/date +%M)"

    if [ "$minute" = "25" ]; then
      ${pkgs.libnotify}/bin/notify-send \
        --urgency=normal \
        --expire-time=20000 \
        --app-name="Break reminder" \
        "EYES — 20 SECONDS" \
        "Look far away. Relax your shoulders."
    else
      ${pkgs.libnotify}/bin/notify-send \
        --urgency=critical \
        --expire-time=60000 \
        --app-name="Break reminder" \
        "BREAK — 5 MINUTES" \
        "Stand up and move."
    fi
  '';
in
{
  systemd.user.services.break-reminder = {
    Unit.Description = "Show a break reminder";

    Service = {
      Type = "oneshot";
      ExecStart = breakReminder;
    };
  };

  systemd.user.timers.break-reminder = {
    Unit.Description = "Eye and movement reminders";

    Timer.OnCalendar = "*-*-* *:25,55:00";

    Install.WantedBy = [
      "timers.target"
    ];
  };
}
