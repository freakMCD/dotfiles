{config, stablePkgs, ...}:
{
  programs = {
    git = {
      enable = true;
      extraConfig.credential.helper = "store --file ~/.my-credentials";
      userEmail = "vastagox@gmail.com";
      userName = "Alex";
    };

    fzf = let command="--color=always . /mnt/DATA ~/nix"; in {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd -t f ${command}";
      fileWidgetCommand = "fd -t f ${command}";
      changeDirWidgetCommand = "fd -t d ${command}";
      fileWidgetOptions = ["--delimiter / --with-nth 4.."];
      defaultOptions = [
        "--ansi --height 60% --reverse --inline-info --color=16" 
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
        };
      };
    };

    ncmpcpp = {
      enable = true;
      package = stablePkgs.ncmpcpp;
      settings = {
        user_interface = "alternative";
        lyrics_directory = "~/Music/lyrics";
        mpd_crossfade_time = 5;
        allow_for_physical_item_deletion = "yes";
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
      package = stablePkgs.zathura;
      options = {
        adjust-open = "width";
        scroll-step = 50;
        selection-clipboard = "clipboard";
        selection-notification = false;
        show-recent = 20;
        recolor-lightcolor = "rgba(241,228,181,0.6)" ;
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
