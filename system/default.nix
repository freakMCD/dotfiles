{ inputs, pkgs, ... }:
{ imports = [
    ./hardware-configuration.nix
    ./options.nix
    ./configuration.nix
    ./autologin.nix
    ./software.nix
    ./networking.nix
    ];
}
