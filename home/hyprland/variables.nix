let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };

  # Slightly bigger mpv window
  mpv = { width = screen.width / 5; height = screen.height / 4; };  # Increased by 50px each

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
