{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;

    policies = import ./policies.nix { inherit config lib; };

    profiles.default = {
      id = 0;
      name = "edwin";
      isDefault = true;

      userChrome = import ./userchrome.nix { inherit config; };

      search = import ./search.nix;

      extensions = {
        force = true;
        settings = {
          "uBlock0@raymondhill.net".settings =
            import ./ublock.nix { inherit lib; };
        };
      };
    };
  };
}
