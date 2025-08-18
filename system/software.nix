{lib, stablePkgs, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
  environment.systemPackages = with pkgs; [
  #Pinned from stablePkgs 
   texlab texlive.combined.scheme-full libreoffice kalker
  #Browsers
   qutebrowser w3m openboard
  #Documents
   pdfarranger simple-scan neovim 
  #Media & Graphics
   gimp qimgv ffmpeg chafa playerctl mpc 
  #Communication
   telegram-desktop neomutt msmtp isync newsraft
  #Dev
   home-manager nvd pass yadm gnupg dig inotify-tools gcc bundix perlEnv pipx 
  #Terminal 
   zip unzip curl rclone udiskie bat fd libnotify ares-cli htop wev

  #hyprland
   yambar wl-clipboard wf-recorder grim slurp hyprpicker

  #Others
   helvum qbittorrent translate-shell
   geogebra6
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

  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = "Sisko";
    transcoding = true;
  };
  services.earlyoom = {
    enable = true;
    extraArgs = [
      "-g"
    ];
  };
}
