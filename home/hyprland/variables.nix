let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };
  
  # Mpv dimensions
  mpv = { width = screen.width * 12 / 24; height = screen.height * 12 / 24; };

  # Coordinates (centered directly on screen)
  x = (screen.width - mpv.width) ;
  y = 0 ;
in builtins.mapAttrs (_name: builtins.toString) {
  inherit (mpv) width height;
  inherit x y;

  rounding = 20;
  high = 0;
  low = 0;
}
