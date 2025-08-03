{ inputs, pkgs, ... }:
{ imports = [
    ./nixpkgs-config.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./autologin.nix
    ./software.nix
    ./networking.nix
    ];
}
