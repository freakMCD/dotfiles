# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system, pkgs, lib, ... }:
let
  perlEnv = pkgs.perl.withPackages (p: with p; [
    MIMEEncWords
  ]);
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

   nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
      optimise.automatic = true;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

  # From https://kokada.dev/blog/an-unordered-list-of-hidden-gems-inside-nixos/
  boot.tmp.useTmpfs = true; 
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  system.switch = {
    enable = false;
    enableNg = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.dbus.implementation = "broker";
  services.fstrim.enable = true;

  # HP scanner
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "hplip"
    ];
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin ];
  };

  # Other
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
 
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    material-symbols
  ];

  environment.variables = {
    GNUPGHOME="$HOME/.local/share/gnupg";
    TEXMFVAR="$HOME/.cache/texlive/texmf-var";
    W3M_DIR="$HOME/.local/share/w3m";
    BROWSER="qutebrowser";
    EDITOR="nvim";	
    MANPAGER="nvim +Man!";
    BUNDLE_FORCE_RUBY_PLATFORM = "true";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

