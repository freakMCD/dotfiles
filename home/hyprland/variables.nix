let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };
  
  # Mpv dimensions
  mpv = { width = screen.width * 15 / 64; height = screen.height * 10 / 36; };

  # Coordinates (centered directly on screen)
  x = (screen.width - mpv.width);
  y = (screen.height - mpv.height);
in builtins.mapAttrs (_name: builtins.toString) {
  inherit (mpv) width height;
  inherit x y;

  rounding = 50;
  high = 0.05;
  low = 0;
}
