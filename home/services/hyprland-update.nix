{ config, pkgs, ... }:

let
  checkHyprlandUpdate = pkgs.writeShellApplication {
    name = "check-hyprland-update";

    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      nix
    ];

    text = ''
      locked="$(
        nix eval --raw \
          '${config.home.homeDirectory}/nix#nixosConfigurations.nixos.config.programs.hyprland.package.version'
      )"

      available="$(
        nix eval --raw \
          github:NixOS/nixpkgs/nixos-unstable#hyprland.version
      )"

      printf 'Locked: %s\nAvailable: %s\n' "$locked" "$available"

      [[ "$locked" == "$available" ]] && exit 0

      state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/hyprland-update-check"
      state_file="$state_dir/notified-version"

      mkdir -p "$state_dir"

      if [[ ! -f "$state_file" ]] ||
         [[ "$(<"$state_file")" != "$available" ]]; then
        notify-send \
          "Hyprland update available" \
          "$locked → $available is now in nixos-unstable"

        printf '%s\n' "$available" > "$state_file"
      fi
    '';
  };
in
{
  home.packages = [ checkHyprlandUpdate ];

  systemd.user.services.hyprland-update-check = {
    Unit.Description = "Check for Hyprland updates in nixos-unstable";

    Service = {
      Type = "oneshot";
      ExecStart =
        "${checkHyprlandUpdate}/bin/check-hyprland-update";
    };
  };

  systemd.user.timers.hyprland-update-check = {
    Unit.Description = "Periodically check for Hyprland updates";

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
