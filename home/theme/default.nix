{lib, config, ... }:

{
  options.dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/nix/home/config/";
  };
  
  options.colors = lib.mkOption {
    type = lib.types.attrs;
    description = "Theme configuration including color palette.";
  };

  config = {
    colors = {
      bg0            = "090505"; # Bg
      bg1            = "0F0F0F";
      bg2            = "1d2021";
      bg3            = "282828";
      bg4            = "32302f";
      gray           = "928374";

      fg0            = "fbf1c7";
      fg1            = "ebdbb2";
      
      muted_white    = "bdae93";
      red            = "cc241d";
      green          = "98971a";
      yellow         = "d79921";
      blue           = "458588";
      magenta        = "b16286";
      cyan           = "689d6a"; 
      white          = "d5c4a1"; # Fg

      b_red     = "fb4934";
      b_green   = "b8bb26";
      b_yellow  = "fabd2f";
      b_blue    = "83a598";
      b_magenta = "d3869b"; # visited
      b_cyan    = "8ec07c"; # unvisited
      b_white   = "a89984"; 

      orange         = "d65d0e";
      b_orange  = "fe8019";
    };
  };
}
