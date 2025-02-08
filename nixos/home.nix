{
  home.stateVersion = "24.11";
  home.sessionPath = [
    "$HOME/bin"
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/edwin/Music/2024/";
    extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
    '';
  };

  services.mpd-mpris = {
    enable = true;
    };

  programs.git = {
    enable = true;
    extraConfig.credential.helper = "store";
  };

  programs.ncmpcpp = {
    enable = true;
    settings = {
      lyrics_directory = "~/Music/lyrics";
      mpd_crossfade_time = 5;
      allow_for_physical_item_deletion = "yes";
      };
    };

  programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
          main = {
              term = "foot";
              font = "JetBrainsMono Nerd Font Mono:pixelsize=14";
              workers = 0;
          };
          colors = {
              alpha = 0.94;
              background = "120000";
              foreground = "fbf1c7";
              regular0="282828";
              regular1="fb4934";
              regular2="b8bb26";
              regular3="fabd2f";
              regular4="83a598";
              regular5="d3869b";
              regular6="8ec07c";
              regular7="d5c4a1";
          };
      };
  };
  services.fnott = {
      enable = true;
      settings = {
          main = {
              max-width = 300;
              default-timeout = 10;
              idle-timeout = 300;
              summary-font = "JetBrainsMono Nerd Font:weight=bold:size=12";
              body-font = "JetBrainsMono Nerd Font:size=11";
              layer = "overlay";
              progress-bar-height = 5;
              padding-vertical = 5;
              padding-horizontal = 10;
              edge-margin-vertical = 24;
              edge-margin-horizontal = 24;
              background = "111111FF";
              border-color = "888888FF";
              summary-format = "%s";
              body-format = "%b";
              title-format = "";
              play-sound = "paplay --volume=35000 \${filename}";
          };
      };
  };
  xdg.enable = true;
  programs.bash = {
    enable = true;
    historyFile = "$XDG_STATE_HOME/bash/history";
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyIgnore = [
      "ls"
      "cd"
      "exit"
      ];
    initExtra = ''
      source ~/.local/share/linuxfedora

      export PS1="\n\[\e[38;2;102;92;84m\][\[\e[38;2;251;73;52m\]\u \[\e[38;2;184;187;38m\]\W\[\e[38;2;102;92;84m\]] \[\e[0m\]"

      export PS4='Line ''${LINENO}: '

      fe() {
        IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
        [[ -n "$files" ]] && $EDITOR "''${files[@]}"
      }

      fmpc() {
        local song_position
        song_position=$(mpc -f "%position%) %artist% - %title%" playlist | \
          fzf --query="$1" --reverse --select-1 --exit-0 | \
          sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
        [ -n "$song_position" ] && mpc -q play $song_position
      }

      mpv() {
          nohup mpv "$@" &>/dev/null & exit
      }
      '';
    sessionVariables = {
      W3M_DIR="$XDG_STATE_HOME/w3m";
      CARGO_HOME="$HOME/.local/share/.cargo/";
      EDITOR="nvim";
      MANPAGER="nvim +Man!";
      PASSWORD_STORE_DIR="$HOME/.PrivateHub/password-store/";
      GNUPGHOME="$XDG_DATA_HOME/gnupg";
      TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var";
      };
    shellAliases = {
      rebuild="sudo nixos-rebuild switch --flake $HOME/nixos#nixos";
      hyprevents="socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  EXEC:'shellevents',nofork";
      reloadevent="pkill -USR1 shellevents";
      dus="du -h --max-depth=1 | sort -hr";
      df="df -h";
      fc-list=''fc-list --format="%{family[0]}\n" | sort | uniq'';
      sortmusic=''cd ~/Music/ && stat --format="%W %n" * | sort -nr'';
      mp3dl="yt-dlp --restrict-filenames --extract-audio --audio-format mp3 --no-playlist";
      litedlp="yt-dlp -f 'bestvideo[height<=720]+bestaudio/best'";

      gpg-list="gpg --list-secret-keys --keyid-format LONG";
      gpg-backup="gpg -o private.gpg --export-options backup --export-secret-keys";
      gpg-restore="gpg --import-options restore --import private.gpg";

      rclone="rclone -P --transfers 45 --checkers 65";
      compresspdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dColorImageResolution=170 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf";
      };
    };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultCommand = "fd -t f -H -L -E '{*[Cc]ache,*.git,.local,opt,auxfiles,nixos*}' ";
    fileWidgetCommand = "fd -t f -H -L -E '{*[Cc]ache,*.git,.local,opt,auxfiles,nixos*}' "; 
    changeDirWidgetCommand = "fd -t d -H -L -E '{*[Cc]ache,*.git,.local,opt,auxfiles,nixos*}' ";
    defaultOptions = [
      "--height 60%" 
      "--color=bg+:#32302f,spinner:#e2d3ba,hl:#ef938e" 
      "--color=fg:#e2d3ba,header:#ef938e,info:#e1acbb,pointer:#e2d3ba"
      "--color=marker:#e2d3ba,fg+:#e2d3ba,prompt:#e1acbb,hl+:#ef938e"
      ];
    };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
