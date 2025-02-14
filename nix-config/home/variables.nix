let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };

  # mpv window dimensions
  mpv = { width = 480; height = 360; };

  # Offsets
  offset = { x = -10; y = 25; };

  # mpv coordinates
  x1 = screen.width - offset.x - mpv.width;
  y1 = screen.height - offset.y - mpv.height;
in builtins.mapAttrs (_name: toString) {
  inherit (mpv) width height;  # Makes mpv_width available as width
  inherit x1 y1;  # Makes mpv_width available as width
  high = 0.74;
  low = 0;

  x2 = x1;
  y2 = 0;

  x3 = 0;
  y3 = x1;

  x4 = 0;
  y4 = y1;
}


