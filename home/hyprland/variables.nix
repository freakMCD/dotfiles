let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };
  
  # Mpv dimensions
  mpv = { width = screen.width * 3 / 24; height = screen.height * 4 / 24; };

  # Coordinates (centered directly on screen)
  x = (screen.width - mpv.width) / 2 ;
  y = (screen.height - mpv.height) + 10;
in builtins.mapAttrs (_name: builtins.toString) {
  inherit (mpv) width height;
  inherit x y;

  rounding = 20;
  high = 0.75;
  low = 0;
}
