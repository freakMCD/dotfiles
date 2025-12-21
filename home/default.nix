{config, lib, inputs, pkgs, ... }: 
{
  imports = [
    ./tv/renew-token.nix
    ./theme
    ./shell-scripts.nix
    ./services.nix
    ./programs.nix
    ./terminal.nix
    ./mpv.nix
    ./xdg.nix
  ];

  home = {
    sessionPath = [ "$HOME/.local/bin"];
    sessionVariables = {
      GNUPGHOME="$HOME/.local/share/gnupg";
      TEXMFVAR="$HOME/.cache/texlive/texmf-var";
      W3M_DIR="$HOME/.local/share/w3m";
      EDITOR="nvim";	
      MANPAGER="nvim +Man!";
      BUNDLE_FORCE_RUBY_PLATFORM = "true";
    };
    username = "edwin";
    homeDirectory = "/home/edwin/";
    stateVersion = "24.11";
  };
}
