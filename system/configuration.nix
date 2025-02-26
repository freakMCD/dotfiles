# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system, pkgs, ... }:
let
  perlEnv = pkgs.perl.withPackages (p: with p; [
    MIMEEncWords
  ]);
  defaultNameservers = [
    "9.9.9.9"
    "9.9.9.10"
    "9.9.9.11"
    "2620:fe::9"
    "2620:fe::10"
    "2620:fe::11"
  ];
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    useDHCP = false;
    nameservers = defaultNameservers;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=no # This is handled by Avahi.
    '';
    domains = ["~."];
    fallbackDns = defaultNameservers;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

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
    BUNDLE_FORCE_RUBY_PLATFORM = "true";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

