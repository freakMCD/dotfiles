{ inputs, pkgs, ... }:
{ imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    ./autologin.nix
    ./software.nix
    ];
}
