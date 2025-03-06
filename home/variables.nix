let
  # Screen dimensions
  screen = { width = 1920; height = 1080; };

  # mpv window dimensions
  mpv = { width = 320; height = 240; };

  # Offsets
  offset = { x = 10; y = 10; };

  # Grid cell size
  cell = { width = screen.width / 3; height = screen.height / 3; };

  # X positions (left to right)
  x1 = 0;                                                # Left edge
  x2 = cell.width + (cell.width - mpv.width) / 2;        # Centered properly
  x3 = screen.width - mpv.width;                         # Right edge

  x4 = x1;
  x5 = x2;
  x6 = x3;

  x7 = x1;
  x8 = x2;
  x9 = x3;

  # Y positions (bottom to top)
  y1 = screen.height - mpv.height;  # Bottom row
  y2 = y1;
  y3 = y1;

  y4 = cell.height;                 # Middle row
  y5 = y4;
  y6 = y4;

  y7 = 0;                           # Top row
  y8 = y7;
  y9 = y7;
in builtins.mapAttrs (_name: builtins.toString) {
  # mpv dimensions
  inherit (mpv) width height;

  # X coordinates
  inherit x1 x2 x3 x4 x5 x6 x7 x8 x9;

  # Y coordinates
  inherit y1 y2 y3 y4 y5 y6 y7 y8 y9;

  # Extra settings
  rounding = 50;
  high = 0.75;
  low = 0.1;
}

