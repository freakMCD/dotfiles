{config, lib, inputs, pkgs, ... }: 
{
  imports = [
    ./tv/renew-token.nix
    ./theme
    ./shell-scripts.nix
    ./services.nix
    ./programs.nix
    ./terminal.nix
    ./xdg.nix
    ./applications/firefox.nix
    ./applications/mpv.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  home = {
    sessionPath = [ "$HOME/.local/bin"];
    sessionVariables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
      GNUPGHOME="$HOME/.local/share/gnupg";
      TEXMFVAR="$HOME/.cache/texlive/texmf-var";
      W3M_DIR="$HOME/.local/share/w3m";
      EDITOR="nvim";	
      MANPAGER="nvim +Man!";
      BUNDLE_FORCE_RUBY_PLATFORM = "true";
      TEXINPUTS = "$HOME/nix/latex/preamble:";
    };
    username = "edwin";
    stateVersion = "26.05";

    file = {
      ".local/bin/ytclip" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/scripts/dev/ytclip";
      };

      ".local/bin/updmusic" = {
        source = ../scripts/dev/updmusic.py;
        executable = true;
      };
    };

  };
}
