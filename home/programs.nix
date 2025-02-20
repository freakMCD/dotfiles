{
  programs.git = {
    enable = true;
    extraConfig.credential.helper = "store";
    userEmail = "vastagox@gmail.com";
    userName = "Alex";
  };

  programs.fzf = 
  let
    command="--color=always . /mnt/DATA ~/nix";
  in
  {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd -t f ${command}";
    fileWidgetCommand = "fd -t f ${command}";
    changeDirWidgetCommand = "fd -t d ${command}";
    fileWidgetOptions = ["--delimiter / --with-nth 4.."];
    defaultOptions = [
      "--preview 'bat --style=numbers --color=always --line-range=:100 {}'"
      "--ansi --height 60% --reverse" 
      "--color=bg+:#32302f,spinner:#e2d3ba,hl:#ef938e" 
      "--color=fg:#e2d3ba,header:#ef938e,info:#e1acbb,pointer:#e2d3ba"
      "--color=marker:#e2d3ba,fg+:#e2d3ba,prompt:#e1acbb,hl+:#ef938e"
      ];
    };

  programs.yazi = {
    enable = true;
    enableFishIntegration= true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = false;
        sort_dir_first = true;
      };
    };
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
              background = "100b0b";
              foreground = "fbf1c7";
              regular0   = "282828";
              regular1   = "fb4934";
              regular2   = "b8bb26";
              regular3   = "fabd2f";
              regular4   = "83a598";
              regular5   = "d3869b";
              regular6   = "8ec07c";
              regular7   = "d5c4a1";
          };
      };
  };

  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "width";
      scroll-step = 50;
      selection-clipboard = "clipboard";
      selection-notification = false;
      show-recent = 20;
      recolor-lightcolor = "rgba(245,200,150,0.75)" ;
      recolor-darkcolor = "#000000";
      recolor = true;
      recolor-keephue = true;
      default-bg = "rgba(0,0,0,7)";
      default-fg = "#000000";
      render-loading = true;
    };
  };
}
