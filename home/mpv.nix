{ pkgs, lib, config, ...}: let
  yt-dlp = pkgs.yt-dlp.overrideAttrs (old: {
    version = "2025.3.27";
    src = pkgs.fetchPypi {
      pname = "yt_dlp";
      version = "2025.3.27";
      hash = "sha256-MMsHj4A7U5sqZlIcXshtMowH90rsqUQAaeWGGcKZzxU=";
    };
    postPatch = "";
  });
in
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      keep-open = true;
      profile = "fast";
      video-sync = "display-resample";
      gpu-context = "wayland";
      save-position-on-quit = true;
      watch-later-options = "start";
      force-window = true;
      screenshot-directory = "~/MediaHub/screenshots/mpv";
      osd-bar= false;
      osd-font-size = 20;

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
      ytdl-format = "bv*[vcodec!^=av01][height<=1080]+ba/bv*[height<=1080]+ba";
      demuxer-lavf-o="extension_picky=0";
      force-seekable= true;
      demuxer-max-bytes = "500M";
      demuxer-max-back-bytes="250MiB";
      demuxer-donate-buffer = false;
      prefetch-playlist= true;
      cache-pause-initial = true;
      cache-pause-wait = 3;
    };

    profiles = {
      "not fullscreen" = {
        profile-restore = "copy";
        profile-cond = "(osd_width < 1280)";
        video-zoom = 0.6;
        sub-visibility = false;
        
      };
    };

    bindings = {
      "ESC" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
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
        font_size = 7;
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
          pname = "mpv-simple-history";
          version = "1.0";

          src = fetchFromGitHub {
            owner = "Eisa01";
            repo = "mpv-scripts";
            rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
            sha256 = "sha256-95CAKjBRELX2f7oWSHFWJnI0mikAoxhfUphe9k51Qf4=";
          };

          passthru.updateScript = unstableGitUpdater {};
          scriptPath = "scripts/SimpleHistory.lua";

          meta = {
            description = "Stores whatever you open in a history file and abuses it with features!";
            homepage = "https://github.com/Eisa01/mpv-scripts";
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
    yt-dlp
    (writeShellApplication {
      name = "mpvl";
      runtimeInputs = with pkgs; [ wl-clipboard ];
      text = ''
        mpv "$(wl-paste)"
      '';
    })
  ];
}
