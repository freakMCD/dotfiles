{lib, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "hplip" "geogebra" "unrar"];
environment.systemPackages = with pkgs; [
# System
  home-manager yadm gnupg pass gcc mpc puddletag btop qbittorrent
# Terminal
  curl ethtool fd p7zip rclone udiskie unrar jq ripgrep
# Desktop
  grimblast hypridle hyprpicker kitty libnotify wev wl-clipboard
# Documents
  xournalpp pdfarranger simple-scan
  ghostscript # compress pdf
# Writing
  neovim tree-sitter texlab ruff lua-language-server
# Email
  neomutt msmtp isync w3m perlEnv
# Images
  gimp gthumb imagemagick
# Mathematics
  geogebra6 octaveFull
# Latex
  (texliveSmall.withPackages (ps: with ps; [
      scheme-small
      koma-script
      collection-langeuropean
      collection-mathscience
      collection-pictures
      collection-latexextra
      latexmk
  ]))
# Windows
# quickemu  samba
# Python
  (pkgs.python3.withPackages (ps: with ps; [
    mutagen
    numpy
    matplotlib
    opencv4
    scipy
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
  gnupg.agent.enable = true;

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

systemd.user = {
  services.mailsync = {
    description = "Mailboxes sync";
    path = with pkgs; [ bash procps pass isync perl libnotify];
    environment = {
      GNUPGHOME = "%h/.local/share/gnupg";
      PERL5LIB = "${perlEnv}/lib/perl5/site_perl";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/nix/scripts/mail-sync";
    };
  };
  timers.mailsync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "1m";
      OnUnitActiveSec = "15m";
      Persistent = true;
    };
  };
}

;}
