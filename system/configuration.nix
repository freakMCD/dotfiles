# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  boot.loader = {
    timeout = 1;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  nix = {
     gc = {
       automatic = true;
       dates = "weekly";
       options = "--delete-older-than 30d";
     };
     settings.experimental-features = [ "nix-command" "flakes" ];
   };

  # From https://kokada.dev/blog/an-unordered-list-of-hidden-gems-inside-nixos/
  boot.tmp.cleanOnBoot = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # rtkit is optional but recommended
  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services = {
    dbus.implementation = "broker";
    fstrim.enable = true;
    udisks2.enable = true;
    
    # Printing
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Keyboard Layout
     xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
      };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin ];
  };

  # Other
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users.edwin = {
    isNormalUser = true;
    description = "Edwin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
 
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.liberation
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    roboto
    material-symbols
  ];

  system.stateVersion = "24.11";
}

