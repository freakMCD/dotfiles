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
    "hypr".source = "${dotfiles}/hypr";
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

  userDirs = let xdg = "/mnt/DATA/XDG"; in {
    enable = true;

    desktop = "${xdg}/Desktop";
    documents = "${xdg}/Documents";
    download = "${xdg}/Downloads";
    music = "${xdg}/Music";
    pictures = "${xdg}/Pictures";
    videos = "${xdg}/Videos";
    projects = "${xdg}/Projects";
    templates = "${xdg}/Templates";
    publicShare = "${xdg}/Public";
  };
};
}
