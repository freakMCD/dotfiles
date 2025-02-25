{ pkgs, lib, config, ...}: 
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      gpu-context = "wayland";
      keep-open = true;
      save-position-on-quit = true;
      watch-later-options = "start";
      force-window = true;
      screenshot-directory = "~/MediaHub/screenshots/mpv";

      ## OSD ##
      osd-on-seek="msg-bar";
      osd-font-size = 20;
      osd-outline-size = 1.4;
      osd-color="${config.colors.b_red}";
      osd-status-msg="\${time-pos} ~ \${demuxer-cache-duration}";

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
      ytdl-raw-options="format-sort='res:1080,+size'";
      demuxer-max-bytes = "500M";
      demuxer-max-back-bytes="500MiB";
      force-seekable= true;
    };

    bindings = {
      "WHEEL_UP" = "ignore";
      "WHEEL_DOWN" = "ignore";
      "Shift+Ctrl+S" = "script-binding toggle-seeker";
      "Shift+d" = "playlist-remove current";
    };

    scriptOpts = {
      osc = {
        seekbarstyle = "diamond";
        seekrangestyle = "line";
        scalefullscreen = 0.85;
      };
      playlistmanager = {
        playlist_display_timeout = 10;
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
        mpvScripts.mpv-playlistmanager
        mpvScripts.seekTo
    ];
  };
}
