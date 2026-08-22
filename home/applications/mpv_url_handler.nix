{ config, pkgs, lib, ... }:
let
  mpvUrlHandler = pkgs.writeShellApplication {
    name = "mpv-url-handler";
    runtimeInputs = [ pkgs.python3 ];

    text = ''
      exec python3 - "$1" <<'PY'
      import os
      import sys
      from urllib.parse import parse_qs, urlparse

      request = urlparse(sys.argv[1])

      if request.scheme != "mpv" or request.netloc != "open":
          raise SystemExit(1)

      try:
          url = parse_qs(request.query)["url"][0]
      except (KeyError, IndexError):
          raise SystemExit(1)

      parsed = urlparse(url)
      allowed_hosts = {
          "youtube.com",
          "www.youtube.com",
          "m.youtube.com",
          "music.youtube.com",
          "youtu.be",
      }

      if parsed.scheme != "https" or parsed.hostname not in allowed_hosts:
          raise SystemExit(1)

      os.execvp("mpv", ["mpv", "--", url])
      PY
    '';
  };
in {
  home.packages = [ mpvUrlHandler ];

  xdg.desktopEntries.mpv-url-handler = {
    name = "Open YouTube video in mpv";
    exec = "${mpvUrlHandler}/bin/mpv-url-handler %u";
    terminal = false;
    type = "Application";
    noDisplay = true;
    mimeType = [ "x-scheme-handler/mpv" ];
  };

  home.activation.setMpvProtocolHandler =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.xdg-utils}/bin/xdg-mime default \
        mpv-url-handler.desktop \
        x-scheme-handler/mpv
    '';
}
