{config, inputs, pkgs, ... }: {
  imports = [
    ./hypr.nix
    ./services.nix
    ./programs.nix
    ./shell-scripts.nix
    ./terminal.nix
  ];

  xdg.configFile =
  let
    dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/edwin/nix-config/home/config/";
  in
  {
    "nvim".source = "${dotfiles}/nvim";
    "mpv".source = "${dotfiles}/mpv";
    "fastanime/config.ini".source = "${dotfiles}/fastanime/config.ini";
    "neomutt".source = "${dotfiles}/neomutt";
    "qutebrowser".source = "${dotfiles}/qutebrowser";
    "newsraft".source = ./config/newsraft;
    "yambar".source = ./config/yambar;
  };
}
