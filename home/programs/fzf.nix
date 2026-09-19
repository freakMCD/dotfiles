{ pkgs, lib, ... }:

let
  currentCycle = "$HOME/MathCareer/6toCiclo";

  activeFileRoots = [
    currentCycle
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/MediaHub"
    "$HOME/nix"
  ];

  activeDirRoots = [
    currentCycle
    "$HOME/Documents"
    "$HOME/MediaHub"
    "$HOME/nix"
  ];

  allFileRoots = [
    "$HOME/MathCareer"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/MediaHub"
    "$HOME/nix"
  ];

  activeFileRootsStr = lib.concatStringsSep " " activeFileRoots;
  activeDirRootsStr = lib.concatStringsSep " " activeDirRoots;
  allFileRootsStr = lib.concatStringsSep " " allFileRoots;
in
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand =
      "fd -t f --color=always . ${activeFileRootsStr}";

    fileWidget.command =
      "fd -t f --color=always . ${activeFileRootsStr}";

    changeDirWidget.command =
      "fd -t d --color=always . ${activeDirRootsStr}";

    fileWidget.options = [
      "--scheme=path"
      "--delimiter /"
      "--with-nth 4.."
    ];

    changeDirWidget.options = [
      "--scheme=path"
      "--delimiter /"
      "--with-nth 4.."
    ];

    defaultOptions = [
      "--ansi"
      "--reverse"
      "--inline-info"
      "--color" "fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229"
      "--color" "info:150,prompt:110,spinner:150,pointer:167,marker:174"
    ];
  };

  home.packages = [
    (pkgs.writeShellScriptBin "open_file" ''
      if [[ "''${1:-}" == "--all" ]]; then
        selected_file=$(
          fd -t f --color=always . ${allFileRootsStr} |
            fzf \
              --ansi \
              --scheme=path \
              --delimiter / \
              --with-nth 4..
        )
      else
        selected_file=$(
          fd -t f --color=always . ${activeFileRootsStr} |
            fzf \
              --ansi \
              --scheme=path \
              --delimiter / \
              --with-nth 4..
        )
      fi

      [[ -n "$selected_file" ]] || exit 0

      nohup xdg-open "$selected_file" >/dev/null 2>&1 &
      sleep 0.2
      exit
    '')
  ];
}
