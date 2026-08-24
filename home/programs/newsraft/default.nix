{ pkgs, ... }:

{
  home.packages = with pkgs; [
    newsraft
  ];

  xdg.configFile."newsraft/config".source = ./config;
  xdg.configFile."newsraft/feeds".source = ./feeds;
}
