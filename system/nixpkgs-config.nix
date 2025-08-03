{ lib, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "hplip" "geogebra" ];

    packageOverrides = pkgs: {
      hplip = pkgs.hplip.overrideAttrs (oldAttrs: {
        HPLIP_PLUGIN = pkgs.fetchurl {
          url = "https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-3.24.4-plugin.run";
          hash = "sha256-Hzxr3SVmGoouGBU2VdbwbwKMHZwwjWnI7P13Z6LQxao=";
        };
      });
    };
  };
}
