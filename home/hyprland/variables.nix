let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };
  
  # Mpv dimensions
  mpv = { width = screen.width * 16 / 64; height = screen.height * 12 / 36; };

  # Coordinates (centered directly on screen)
  x = (screen.width - mpv.width);
  y = (screen.height - mpv.height);
in builtins.mapAttrs (_name: builtins.toString) {
  inherit (mpv) width height;
  inherit x y;

  rounding = 150;
  high = 0.2;
  low = 0;
}
