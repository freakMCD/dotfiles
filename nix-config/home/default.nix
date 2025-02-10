{ inputs, pkgs, ... }: {
  imports = [
    ./hypr.nix
    ./services.nix
    ./programs.nix
    ./shell-scripts.nix
  ];
}
