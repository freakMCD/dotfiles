{ inputs, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
# List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
      home-manager pass yadm gnupg ffmpeg
      gcc bundix perlEnv
      qutebrowser firefox w3m 
      neovim kalker
      curl rclone udiskie bat fd libnotify
      neomutt msmtp isync newsraft
      nomacs playerctl yt-dlp mpc streamlink
      wev wl-clipboard grim slurp wf-recorder qbittorrent translate-shell
      chafa inputs.fastanime.packages.${system}.default
      texlab texlive.combined.scheme-medium
      hyprpicker yambar webcord
  ];

  programs = {
    hyprland.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      };
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };

  services.udisks2.enable = true;

  systemd.user.services.mailsync = {
    enable = true;
    description = "Mailboxes sync";
    path = [pkgs.bash pkgs.procps pkgs.pass pkgs.isync pkgs.perl pkgs.libnotify];
    environment = {
      GNUPGHOME="%h/.local/share/gnupg";
      PERL5LIB = "${perlEnv}/lib/perl5/site_perl";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "%h/nix/scripts/mailboxes_sync";
    };
    wantedBy = [ "user.target" ];
  };

  systemd.user.timers.mailsync = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
    OnBootSec= "1m";
    OnUnitActiveSec="15m";
    Unit="mailsync.service";
    };
  };

}
