{ pkgs, ... }:

let
  # Unfiltered DNS used only inside the synchronization sandbox.
  syncResolvConf = pkgs.writeText "music-sync-resolv.conf" ''
    nameserver 127.0.0.2
  '';

  syncNsswitchConf = pkgs.writeText "music-sync-nsswitch.conf" ''
    hosts: files dns
  '';

  # yt-dlp is maintained separately in ~/.local/bin.
  musicSync = pkgs.writeShellApplication {
    name = "music-sync";

    runtimeInputs = [
      pkgs.bubblewrap
      pkgs.coreutils
      pkgs.python3
      pkgs.rclone
      pkgs.ffmpeg
      pkgs.deno
      pkgs.atomicparsley
    ];

    text = ''
      script="$HOME/nix/scripts/helpers/music-sync.py"
      music_dir="$HOME/Music"
      rclone_config_dir="$HOME/.config/rclone"

      if [ ! -x "$script" ]; then
        echo "error: script is not executable: $script" >&2
        exit 1
      fi

      mkdir -p -- "$music_dir"

      music_dir="$(realpath "$music_dir")"
      resolv_conf="$(readlink -f /etc/resolv.conf)"
      nsswitch_conf="$(readlink -f /etc/nsswitch.conf)"

      # Make the system read-only, except for Music and rclone's configuration.
      # Hide nscd so applications use the sandbox's DNS configuration.
      exec bwrap \
        --die-with-parent \
        --new-session \
        --unshare-all \
        --share-net \
        --ro-bind / / \
        --proc /proc \
        --dev /dev \
        --tmpfs /tmp \
        --tmpfs /run/nscd \
        --bind "$music_dir" "$music_dir" \
        --bind-try "$rclone_config_dir" "$rclone_config_dir" \
        --ro-bind "${syncResolvConf}" "$resolv_conf" \
        --ro-bind "${syncNsswitchConf}" "$nsswitch_conf" \
        --setenv DENO_DIR /tmp/deno \
        --setenv XDG_CACHE_HOME /tmp/cache \
        -- \
        "$script"
    '';
  };
in
{
  systemd.user.services.music-sync = {
    Unit.Description = "Synchronize local music";

    Service = {
      Type = "oneshot";
      ExecStart = "${musicSync}/bin/music-sync";
    };
  };

  systemd.user.timers.music-sync = {
    Unit.Description = "Periodically synchronize local music";

    Timer = {
      OnStartupSec = "5m";
      OnUnitActiveSec = "24h";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
