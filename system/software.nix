{lib, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
  nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [ "hplip" "geogebra" "unrar" ];

  environment.systemPackages = with pkgs; [
# Utils
  ffmpeg zip unzip curl htop fd rclone udiskie unrar unrar libnotify imagemagick
# Apps
  neovim openboard gthumb avidemux mkvtoolnix geogebra6 pdfarranger simple-scan kalker
# Communication
  neomutt msmtp isync w3m
# Dev
  home-manager nvd pass yadm gnupg dig gcc perlEnv
# Linters
  ruff pylint texlab
# hyprland
  kitty wl-clipboard wf-recorder grim slurp hyprpicker hypridle wev conky 
# Latex
  (texlive.combine {
    inherit (texlive)
      scheme-small
      koma-script
      collection-langeuropean
      collection-mathscience
      collection-pictures
      collection-latexextra
      latexmk;
  })

# Windows
#  quickemu  samba

# Python
(pkgs.python3.withPackages (ps: with ps; [
  numpy
  matplotlib
  opencv4
  scipy
  mutagen # for thumbnails on opus
]))
];

# virtualization 
#programs.virt-manager.enable = true;
#users.groups.libvirtd.members = ["edwin"];
#virtualisation.libvirtd.enable = true;
#virtualisation.spiceUSBRedirection.enable = true;

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
      ExecStart = "%h/nix/scripts/mailboxes-sync";
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

  services.earlyoom = {
    enable = true;
    extraArgs = [
      "-g"
    ];
  };
}
