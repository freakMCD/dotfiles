{ pkgs, lib, config, ...}:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
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
      ytdl-format = "bv[vcodec^=vp9][height<=1080]+ba[ext=m4a]/b[height<=1080]";
      ytdl-raw-options = "cookies-from-browser=firefox";
      force-seekable= true;
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

      youtube = {
        profile-cond = "get('path', ''):find('youtu%.?be')";
        profile-restore = "copy";
        stream-lavf-o = "request_size=10485760";
      };
    };

    bindings = {
      "ESC" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
      "Shift+d" = "playlist-remove current";
    };

    scriptOpts = {
      ytdl_hook = { ytdl_path = "${config.home.homeDirectory}/.local/bin/yt-dlp"; };
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
}
