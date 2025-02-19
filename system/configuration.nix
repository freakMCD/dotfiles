# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system, pkgs, ... }:
let
  perlEnv = pkgs.perl.withPackages (p: with p; [
    MIMEEncWords
  ]);
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  console.keyMap = "es";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.edwin = {
    isNormalUser = true;
    description = "Edwin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "edwin";
  security.sudo.wheelNeedsPassword = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    material-symbols
  ];

  environment.variables = {
    GNUPGHOME="$HOME/.local/share/gnupg";
    PASSWORD_STORE_DIR="$HOME/.PrivateHub/password-store/";
    TEXMFVAR="$HOME/.cache/texlive/texmf-var";
    W3M_DIR="$HOME/.local/share/w3m";
    BROWSER="qutebrowser";
    EDITOR="nvim";	
    MANPAGER="nvim +Man!";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

