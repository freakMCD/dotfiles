{ lib, ... }:

{
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "hplip" "geogebra" "unrar" ];

    overlays = [
      (final: prev: {
        hplip = prev.hplip.overrideAttrs (old: {
          HPLIP_PLUGIN = prev.fetchurl {
            url = "https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.24.4-plugin.run";
            hash = "sha256-Hzxr3SVmGoouGBU2VdbwbwKMHZwwjWnI7P13Z6LQxao=";
          };
        });
      })
    ];
  };
}

