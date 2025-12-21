{config, pkgs, ...}:
let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}";
in
{
xdg = {
  enable = true;
  configFile =
  {
    "nvim".source = "${dotfiles}/nvim";
    "neomutt".source = "${dotfiles}/neomutt";
    "qutebrowser".source = "${dotfiles}/qutebrowser";
    "newsraft".source = "${dotfiles}/newsraft";
    "hypr".source = "${dotfiles}/hypr";
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
