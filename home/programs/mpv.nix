{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    package = pkgs.mpv.override {
      youtubeSupport = false;
    };

    config = {
      # Video
      gpu-context = "wayland";
      hwdec = "vaapi";
      vo = "gpu-next";
      profile = "fast";

      # Playback
      keep-open = true;
      idle = "no";

      # Interface
      osd-bar = false;
    };

    bindings = {
      WHEEL_UP = "ignore";
      WHEEL_DOWN = "ignore";
    };
  };
}
