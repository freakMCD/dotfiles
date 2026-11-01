{lib, pkgs, ... }: let
  perlEnv = pkgs.perl.withPackages (p: with p; [ MIMEEncWords ]);
in
{
nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "hplip" "geogebra" "unrar"];
environment.systemPackages = with pkgs; [
# System
  home-manager yadm pass gcc losslesscut
# Terminal
  curl ethtool fd p7zip rclone unrar ripgrep
# Desktop
  grimblast hypridle kitty libnotify wl-clipboard
# Documents
  xournalpp pdfarranger naps2 ghostscript
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

systemd.services.ethernet-renegotiate =
  let
    interface = "enp34s0";
    user = "edwin";
  in
  {
    description = "Automatic Ethernet renegotiation";
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      ethtool
      coreutils
      util-linux
      libnotify
    ];

    script = ''
      device="/sys/class/net/${interface}"
      uid=$(id -u ${user})
      runtime="/run/user/$uid"

      notification_id=0
      reconnecting=false
      last_attempt=-5

      notify() {
        local title="$1"
        local message="$2"
        local timeout="$3"
        local id

        [[ -S "$runtime/bus" ]] || return 1

        id=$(runuser -u ${user} -- \
          env XDG_RUNTIME_DIR="$runtime" \
          DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime/bus" \
          notify-send \
            -a "Ethernet" \
            -u normal \
            -t "$timeout" \
            -p \
            -r "$notification_id" \
            "$title" "$message") || return 1

        [[ "$id" =~ ^[0-9]+$ ]] || return 1
        notification_id="$id"
      }

      while true; do
        speed="unknown"
        carrier=0

        if [[ -r "$device/carrier" ]]; then
          read -r carrier < "$device/carrier" || carrier=0
        fi

        if [[ "$carrier" == 1 ]]; then
          read -r speed < "$device/speed" 2>/dev/null ||
            speed="unknown"
        fi

        if [[ "$carrier" == 1 && "$speed" == 10 ]]; then
          if [[ "$reconnecting" == false ]]; then
            reconnecting=true
            notification_id=0
            echo "Ethernet degraded to 10 Mbps"
          fi

          if (( notification_id == 0 )); then
            notify \
              "Ethernet: Reconnecting" \
              "Negotiating a faster connection..." \
              0 || true
          fi

          if (( SECONDS - last_attempt >= 5 )); then
            last_attempt=$SECONDS

            echo "Restarting Ethernet autonegotiation"
            ethtool -r ${interface} ||
              echo "Renegotiation request failed" >&2
          fi

        elif [[ "$speed" =~ ^[0-9]+$ ]] &&
             (( speed >= 100 )); then

          if [[ "$reconnecting" == true ]]; then
            echo "Ethernet restored: $speed Mbps"

            notify \
              "Ethernet: Connected" \
              "Link established at $speed Mbps." \
              5000 || true

            reconnecting=false
            notification_id=0
          fi

        elif [[ "$reconnecting" == true &&
                "$notification_id" == 0 ]]; then
          notify \
            "Ethernet: Reconnecting" \
            "Waiting for the Ethernet link..." \
            0 || true
        fi

        sleep 1
      done
    '';

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 2;
    };
  };


  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  services.tailscale.enable = true;
}
