{config, ...}:
{
  programs = {
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/MediaHub/screenshots/";
    };
    git = {
      enable = true;
      settings = {
        credential.helper = "store --file ~/.my-credentials";
        user = {
          email = "vastagox@gmail.com";
          name = "Alex";
        };
      };
    };

    fzf = let command="--color=always . /mnt/DATA ~/nix"; in {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd -t f ${command}";
      fileWidgetCommand = "fd -t f ${command}";
      changeDirWidgetCommand = "fd -t d ${command}";
      fileWidgetOptions = ["--delimiter / --with-nth 4.."];
      defaultOptions = [
        "--ansi"
        "--height" "60%"
        "--reverse"
        "--inline-info"
        "--color" "fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229"
        "--color" "info:150,prompt:110,spinner:150,pointer:167,marker:174"
      ];
    };

    yazi = {
      enable = true;
      enableFishIntegration= true;
      settings = {
        log = {
          enabled = false;
        };
        mgr = {
          show_hidden = false;
          sort_dir_first = true;
          sort_by = "natural";
        };
        opener = {
          image = [{run = ''gthumb "$@"'';}];
          pdf = [{ run = ''zathura "$@"''; }];
          video = [{ run = ''mpv "$@"''; }];
          text = [{run=''nvim "$@"'';}];
          markdown= [{run=''nvim "$@"'';}];
        };
        open = {
          prepend_rules = [
            { url = "*.tif"; use = "image"; }
            { url = "*.jpg"; use = "image"; }
            { url = "*.jpeg"; use = "image"; }
            { url = "*.png"; use = "image"; }
            { url = "*.gif"; use = "image"; }
            { url = "*.bmp"; use = "image"; }
            { url = "*.svg"; use = "image"; }
            { url = "*.pdf";  use = "pdf"; }
            { url = "*.mp4";  use = "video"; }
          ];
        };
      };
    };

    foot = {
        enable = true;
        server.enable = true;
        settings = {
            main = {
                term = "foot";
                font = "JetBrainsMono Nerd Font Mono:size=12";
                workers = 0;
            };
            colors = {
                alpha = 0.92;
                background = config.colors.bg0;
                foreground = config.colors.white;
                regular0   = config.colors.bg1 ;
                regular1   = config.colors.red ;
                regular2   = config.colors.green ;
                regular3   = config.colors.yellow ;
                regular4   = config.colors.blue ;
                regular5   = config.colors.magenta ;
                regular6   = config.colors.cyan ;
                regular7   = config.colors.white ;
                bright0 = config.colors.gray;
                bright1 = config.colors.b_red;
                bright2 = config.colors.b_green;
                bright3 = config.colors.b_yellow;
                bright4 = config.colors.b_blue;
                bright5 = config.colors.b_magenta;
                bright6 = config.colors.b_cyan;
                bright7 = config.colors.b_white;
            };
        };
    };

    zathura = {
      enable = true;
      options = {
        adjust-open = "width";
        scroll-step = 50;
        selection-clipboard = "clipboard";
        selection-notification = false;
        show-recent = 20;
        recolor-lightcolor = "rgba(245,232,190,0.7)" ;
        recolor-darkcolor = "#000000";
        recolor = true;
        recolor-keephue = true;
        default-bg = "rgba(0,0,0,7)";
        default-fg = "#000000";
        render-loading = true;
      };
    };
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=18";
          terminal = "footclient -e";
          lines = 20;
          width = 40;
          tabs = 4;
          horizontal-pad = 8;
          vertical-pad = 8;
          inner-pad = 4;
        };
        colors = {
          background = "${config.colors.bg1}da";
          selection = "${config.colors.bg3}ff";
        };
      };
    };
  };
}
