{lib, inputs, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
  libnotify = pkgs.libnotify.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = "mirror://gnome/sources/libnotify/0.8/libnotify-0.8.6.tar.xz";
      hash = "sha256-xVQKrvtg4dY7HFh8BfIoTr5y7OfQwOXkp3jP1YRLa1g=";
    };
    patches = "";
  });

  pinned = inputs.nixpkgs-020425.legacyPackages.${pkgs.system};  # Access pinned packages
in
{
  nixpkgs.overlays = [
    (final: prev: {
      firefox = pinned.firefox;
      kalker = pinned.kalker;
      texlive.combined.scheme-full = pinned.texlive.combined.scheme-full;
      texlab = pinned.texlab;
      libreoffice = pinned.libreoffice;
    })
  ];

  environment.systemPackages = with pkgs; [
  #Pinned
   firefox texlab texlive.combined.scheme-full libreoffice kalker
  #Browsers
   qutebrowser w3m webcord openboard
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
   inputs.fastanime.packages.${system}.default
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
}
