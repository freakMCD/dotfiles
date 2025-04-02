let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };
  
  # Mpv dimensions
  mpv = { width = screen.width * 13 / 64; height = screen.height * 10 / 36; };

  # Coordinates (centered directly on screen)
  x = (screen.width - mpv.width);
  y = (screen.height - mpv.height) / 2;
in builtins.mapAttrs (_name: builtins.toString) {
  inherit (mpv) width height;
  inherit x y;

  rounding = 10;
  high = 0.8;
  low = 0;
}
