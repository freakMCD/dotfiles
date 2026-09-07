{ pkgs, ...}:
{
  programs.mpv = {
    enable = true;
    config = {
      gpu-context = "wayland";
      hwdec = "vaapi";
      vo = "gpu-next";
      keep-open = true;
      keep-open-pause = true;
      idle = "yes";
      profile = "fast";
      save-position-on-quit = true;
      watch-later-options = "start";
      save-watch-history = true;
      force-window = true;
      screenshot-directory = "~/MediaHub/screenshots/mpv";
      osd-bar= false;
      osd-font-size = 18;

      ## Languages ##
      slang="eng,en,enUS,en-US,spa,es";
      alang="Japanese,jpn,ja,Korean,kor,ko,eng,en,enUS,en-US,spa,es";

      ## Subtitles ##
      sub-auto="fuzzy";
      sub-scale-by-window="no";
      sub-ass-override="force";

      sub-font-size=42;
      sub-spacing=0.5;

      ## Streaming ##
      ytdl-format = "bv[height<=1080]+ba/b[height<=1080]";
      ytdl-raw-options = "cookies-from-browser=firefox,compat-options=prefer-vp9-sort";
      demuxer-max-bytes = "1GiB";
      demuxer-max-back-bytes = "500MiB";
      demuxer-donate-buffer = false;
    };

    profiles = {
      "protocol.http" = {
        cache = true;
        force-window = "immediate";
      };
      "protocol.https" = { profile = "protocol.http"; };
    };

    bindings = {
      "ESC" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
    };

    scriptOpts = {
      osc = {
        layout = "slimbox";
        seekbarstyle = "knob";
        seekbarhandlesize = 0.6;
        valign = -0.9;
        deadzonesize = 0;
        scrollcontrols = false;
        hidetimeout = 500;
        vidscale = false;
        minmousemove = 4;
      };
      stats = {
        font_size = 18;
      };
    };

    scripts = with pkgs; [
        (mpvScripts.buildLua {
          pname = "show-osc-on-seek";
          version = "1.0";
          src = pkgs.writeTextFile {
            name = "show-osc-on-seek-src";
            text = ''
              mp.observe_property("seeking", "native", function(_, seeking)
                if seeking then
                    mp.command("script-message osc-show")
                end
              end)
            '';
            destination = "/show-osc-on-seek.lua";
          };
          scriptPath = "show-osc-on-seek.lua";
        })
    ];
  };
}
