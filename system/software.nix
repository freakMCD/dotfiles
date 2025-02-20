{ inputs, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
# List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
      home-manager
      gcc
      gnupg pass yadm
      qutebrowser firefox w3m neovim zathura kalker
      foot fnott fuzzel
      curl rclone
      neomutt msmtp newsraft
      nomacs mpv mpvScripts.mpris playerctl yt-dlp mpd mpd-mpris mpc ncmpcpp streamlink
      yazi udiskie bat fd fzf libnotify
      wev wl-clipboard wpaperd grim slurp wf-recorder yambar qbittorrent
      translate-shell
      chafa inputs.fastanime.packages.${system}.default
      isync
      perlEnv
      texlab texlive.combined.scheme-medium
  ];

  programs = {
    hyprland.enable = true;
    fish.enable = true;
    git.enable = true;
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

  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];

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
