{ pkgs, lib, config, ...}:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      gpu-context = "wayland";
      keep-open = true;
      keep-open-pause = false;
      idle = "once";
      profile = "fast";
      video-sync = "display-resample";
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
      ytdl-format = "bv[height<=?1080]+ba/b";
      demuxer-lavf-o="extension_picky=0";
      force-seekable= true;
      demuxer-max-bytes = "1000M";
      demuxer-max-back-bytes="250MiB";
      demuxer-donate-buffer = false;
    };

    profiles = {
      "not fullscreen" = {
        profile-restore = "copy";
        profile-cond = "(osd_width < 1280)";
        video-zoom = 0.6;
        sub-visibility = false;
        
      };
      "protocol.http" = {
        cache = "yes";
        cache-pause = false;
        force-window = "immediate";
      };
      "protocol.https" = { profile = "protocol.http"; };
      "protocol.ytdl" = { profile = "protocol.http"; };

    };

    bindings = {
      "ESC" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
      "f" = "ignore";
      "Shift+d" = "playlist-remove current";
    };

    scriptOpts = {
      osc = {
        layout = "slimbox";
        seekbarstyle = "knob";
        seekbarhandlesize = 0.6;
        valign = -0.9;
        seekrangestyle = "bar";
        deadzonesize = 0;
        scrollcontrols = false;
        scalewindowed = 2;
        hidetimeout = 2000;
      };
      playlistmanager = {
        playlist_display_timeout = 10;
      };
      stats = {
        font_size = 18;
      };
    };

    scripts = with pkgs; [
        (mpvScripts.buildLua {
           pname = "mpv-sockets";
           version = "1.0";

           src = fetchFromGitHub {
             owner = "wis";
             repo = "mpvSockets";
             rev = "be9b7ca84456466e54331bab59441ac207659c1c";
             sha256 = "sha256-tcY+cHvkQpVNohZ9yHpVlq0bU7iiKMxeUsO/BRwGzAs=";
           };

          passthru.updateScript = unstableGitUpdater {};
          scriptPath = "mpvSockets.lua";

           meta = {
             description = "mpvSockets lua module for mpv";
             homepage = "https://github.com/wis/mpvSockets";
             license = lib.licenses.mit;
           };
        })

        (mpvScripts.buildLua {
          pname = "show-osc-on-seek";
          version = "1.0";
          src = pkgs.writeTextFile {
            name = "show-osc-on-seek-src";
            text = ''
              mp.observe_property("seeking", "native", function(_, seeking)
                if seeking then
                    if mp.get_property_bool("fullscreen") then
                        local title = mp.get_property("media-title") or mp.get_property("filename")
                        mp.osd_message(title, 2)  -- Display title for 2 seconds
                    end
                    mp.command("script-message osc-show")
                end
              end)
            '';
            destination = "/show-osc-on-seek.lua";
          };
          scriptPath = "show-osc-on-seek.lua";
        })
        mpvScripts.mpv-playlistmanager
    ];
  };
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "mpvl";
      runtimeInputs = with pkgs; [ wl-clipboard ];
      text = ''
        mpv "$(wl-paste)"
      '';
    })
  ];
}
