{lib, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
  environment.systemPackages = with pkgs; [
  octaveFull libreoffice-fresh kalker openboard slurp kitty scilab-bin zoom pavucontrol
#Browsers
  qutebrowser w3m
#Documents
  pdfarranger simple-scan neovim 
#Media & Graphics
  gimp qimgv ffmpeg chafa
#Communication
  telegram-desktop neomutt msmtp isync newsraft
#Dev
  home-manager nvd pass yadm gnupg dig inotify-tools gcc perlEnv pipx 
#Terminal 
  zip unzip curl rclone udiskie bat fd libnotify ares-cli htop wev unrar

#hyprland
  wf-recorder hyprpicker yambar hypridle

#Others
  qbittorrent geogebra6

#Latex
  texlab
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
  quickemu  samba
];

# virtualization 
#programs.virt-manager.enable = true;

users.groups.libvirtd.members = ["edwin"];
virtualisation.libvirtd.enable = true;
virtualisation.spiceUSBRedirection.enable = true;

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
