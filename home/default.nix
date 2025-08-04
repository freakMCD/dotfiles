{config, lib, inputs, pkgs, ... }: 
{
  imports = [
    ./tv/renew-token.nix
    ./theme
    ./hyprland
    ./services.nix
    ./programs.nix
    ./terminal.nix
    ./mpv.nix
  ];

  home = {
    sessionPath = [ "$HOME/.local/bin"];
    sessionVariables = {
      GNUPGHOME="$HOME/.local/share/gnupg";
      TEXMFVAR="$HOME/.cache/texlive/texmf-var";
      W3M_DIR="$HOME/.local/share/w3m";
      BROWSER="zen";
      EDITOR="nvim";	
      MANPAGER="nvim +Man!";
      BUNDLE_FORCE_RUBY_PLATFORM = "true";
    };
    username = "edwin";
    homeDirectory = "/home/edwin/";
    stateVersion = "24.11";
  };

  xdg = {
    enable = true;
    configFile =
    let
      dotfiles = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}";
    in
    {
      "nvim".source = "${dotfiles}/nvim";
      "fastanime/config.ini".source = "${dotfiles}/fastanime/config.ini";
      "neomutt".source = "${dotfiles}/neomutt";
      "newsraft".source = "${dotfiles}/newsraft";
      "yambar".source = "${dotfiles}/yambar";
    };

    desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      exec = "${pkgs.foot}/bin/foot -- nvim";
      terminal = false;
      icon = "nvim";
      startupNotify = false;
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
  };
}
