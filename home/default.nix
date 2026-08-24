{config, lib, inputs, pkgs, ... }:
{
  imports = [
    ./programs
    ./services
    ./shell
    ./theme
    ./xdg.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  home = {
    sessionPath = [ "$HOME/.local/bin"];
    sessionVariables = {
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
