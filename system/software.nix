{lib, inputs, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
  libnotify = pkgs.libnotify.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "mirror://gnome/sources/libnotify/0.8/libnotify-0.8.6.tar.xz";
      hash = "sha256-xVQKrvtg4dY7HFh8BfIoTr5y7OfQwOXkp3jP1YRLa1g=";
    };
    patches = "";
  });
in
{
# List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
      dig htop inotify-tools streamlink telegram-desktop firefox ffmpeg
      home-manager nvd pass yadm gnupg simple-scan
      gcc bundix perlEnv
      qutebrowser w3m 
      neovim kalker
      curl rclone udiskie bat fd libnotify
      neomutt msmtp isync newsraft
      nomacs playerctl mpc
      wev wl-clipboard grim slurp wf-recorder qbittorrent translate-shell
      chafa inputs.fastanime.packages.${system}.default
      texlab texlive.combined.scheme-medium
      hyprpicker yambar webcord
  ];

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

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
