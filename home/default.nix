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
    ./applications/yt-dlp.nix
    ./applications/mpv_url_handler.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
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
  };
  home.file.".latexmkrc".text = ''
    $sleep_time = 0.1;
  '';
}
