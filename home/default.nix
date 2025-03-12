{config, lib, inputs, pkgs, ... }: {
  imports = [
    ./hypr.nix
    ./services.nix
    ./programs.nix
    ./shell-scripts.nix
    ./terminal.nix
    ./mpv.nix
  ];

  xdg.configFile =
  let
    dotfiles = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}";
  in
  {
    "nvim".source = "${dotfiles}/nvim";
    "fastanime/config.ini".source = "${dotfiles}/fastanime/config.ini";
    "neomutt".source = "${dotfiles}/neomutt";
    "qutebrowser".source = "${dotfiles}/qutebrowser";
    "newsraft".source = "${dotfiles}/newsraft";
    "yambar".source = "${dotfiles}/yambar";
  };

  xdg.desktopEntries.nvim = {
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

  xdg.desktopEntries.qutebrowser = {
    name = "QuteBrowser";
    genericName = "Web Browser";
    comment = "A keyboard-driven, vim-like browser based on Python and Qt";
    icon = "qutebrowser";
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    exec = "qutebrowser --untrusted-args %u";
    terminal = false;
    startupNotify = false;
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/rdf+xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/qute"
    ];
    actions = {
      new-window = {
        name = "New Window";
        exec = "qutebrowser";
      };
      preferences = {
        name = "Preferences";
        exec = ''qutebrowser "qute://settings"'';
      };
    };
    settings.StartupWMClass = "qutebrowser";
  };
}
