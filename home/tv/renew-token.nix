{ config, pkgs, ... }:

let
  scriptPath = "/home/edwin/.local/share/renew-tv-token.sh";
in {
  systemd.user.services.renew-tv-token = {
    Unit = {
      Description = "Renew LG WebOS Dev Mode Token";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${scriptPath}";
    };
    Install = {
      WantedBy = [ "user.target" ];
    };
  };

  systemd.user.timers.renew-tv-token = {
    Unit = {
      Description = "Timer for WebOS token renewal";
    };
    Timer = {
      OnBootSec="1m";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

