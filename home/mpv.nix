{ pkgs, lib, config, ...}: 
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      title="\${filename}";
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
      ytdl-raw-options = ''format-sort="res:1080,codec:vp9.2,+size,+br"'';
      cache = "yes";
      force-seekable= true;
      demuxer-max-bytes = "300M";
      demuxer-max-back-bytes="200MiB";
      demuxer-hysteresis-secs = 10;
      demuxer-donate-buffer = false;
      prefetch-playlist= true;
      cache-pause-initial = true;
      cache-pause-wait = 5;
    };

    profiles = {
      "not fullscreen" = {
        profile-restore = "copy";
        profile-cond = "(osd_width < 1280)";
        video-zoom = 0.4;
        sub-visibility = false;
        
      };
      "protocol.https" = {
        title= "\${media-title}";
      };
    };

    bindings = {
      "ESC" = "ignore";
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
      "Shift+Ctrl+S" = "script-binding toggle-seeker";
      "Shift+d" = "playlist-remove current";
    };

    scriptOpts = {
      osc = {
        seekbarstyle = "diamond";
        seekbarhandlesize = 0.5;
        seekrangestyle = "line";
        deadzonesize = 1;
        scalefullscreen = 0.85;
        scalewindowed = 1.5;
        hidetimeout = 1000;
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
              mp.observe_property('seeking', 'native', function(_, seeking)
                  if seeking then
                      mp.command('script-message osc-show')
                  end
              end)
            '';
            destination = "/show-osc-on-seek.lua";
          };
          scriptPath = "show-osc-on-seek.lua";
        })

        mpvScripts.mpv-playlistmanager
        mpvScripts.seekTo
        mpvScripts.mpris
    ];
  };
}
