{ pkgs, ... }:

let
  roots = ''"$HOME/MathCareer" "$HOME/Documents" "$HOME/Downloads" "$HOME/MediaHub" "$HOME/nix"'';

  fileCommand = "${pkgs.fd}/bin/fd -t f --color=always . ${roots}";

  pathOptions = [
    "--scheme=path"
    "--delimiter=/"
    "--with-nth=4.."
  ];
in
{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = fileCommand;

    fileWidget = {
      command = fileCommand;
      options = pathOptions;
    };

    changeDirWidget = {
      command = "${pkgs.fd}/bin/fd -t d --color=always . ${roots}";
      options = pathOptions;
    };

    defaultOptions = [
      "--ansi"
      "--reverse"
      "--inline-info"
      "--color=fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229"
      "--color=info:150,prompt:110,spinner:150,pointer:167,marker:174"
    ];
  };

  home.packages = [
    (pkgs.writeShellScriptBin "open_file" ''
      selected_file=$(
        ${fileCommand} |
          ${pkgs.fzf}/bin/fzf \
            --ansi \
            --scheme=path \
            --delimiter=/ \
            --with-nth=4..
      ) || exit 0

      [[ -n "$selected_file" ]] || exit 0

      ${pkgs.coreutils}/bin/nohup \
        ${pkgs.xdg-utils}/bin/xdg-open "$selected_file" \
        >/dev/null 2>&1 &

      sleep 0.2
    '')
  ];
}
