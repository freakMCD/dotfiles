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
    "yambar".source = ./config/yambar;
  };
}
