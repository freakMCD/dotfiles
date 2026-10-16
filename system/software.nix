{lib, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "hplip" "geogebra" "unrar"];
environment.systemPackages = with pkgs; [
# System
  home-manager yadm pass gcc shotcut
# Terminal
  curl ethtool fd p7zip rclone udiskie unrar jq ripgrep
# Desktop
  grimblast hypridle kitty libnotify wl-clipboard
# Documents
  xournalpp pdfarranger simple-scan ghostscript
# Writing
  neovim tree-sitter texlab ruff lua-language-server
# Email
  neomutt
# Images
  gthumb
# Mathematics
  geogebra6 octaveFull
# Latex
  (texliveSmall.withPackages (ps: with ps; [
      koma-script
      collection-langeuropean
      collection-mathscience
      collection-pictures
      collection-latexextra
      latexmk
  ]))

# Python
  (pkgs.python3.withPackages (ps: with ps; [
    numpy
    matplotlib
    scipy
  ]))
];


programs = {
  appimage = {
    enable = true;
    binfmt = true;
  };

  hyprland = {
    enable = true;
    withUWSM = true;
  };

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
    path = with pkgs; [ bash procps pass isync perlEnv libnotify];
    environment = {
      GNUPGHOME = "%h/.local/share/gnupg";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/nix/scripts/helpers/mail-sync";
    };
  };
  timers.mailsync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnStartupSec = "1m";
      OnUnitActiveSec = "15m";
    };
  };
};

}
