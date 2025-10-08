{
  programs.bash = {
    enable = true;
    initExtra = '' source ~/.local/share/linuxfedora '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = /* fish */''
      set fish_greeting
      set -U fish_features qmark-noglob
      fish_config prompt choose nim
      source ~/.local/share/linuxfedora

      function fe
          set -l files (fzf --delimiter / --with-nth 4.. --query="$argv" --multi --select-1 --exit-0 | string split0)
          if test -n "$files"
            eval $EDITOR $files
          end
      end

      function fmpc
          set -l song_position (mpc -f "%position%) %artist% - %title%" playlist | \
              fzf --query="$argv" --reverse --select-1 --exit-0 | \
              sed -n 's/^\([0-9]\+\)).*/\1/p')

          if test -n "$song_position"
              mpc -q play $song_position
          end
      end

      function mpv
          nohup mpv $argv >/dev/null 2>&1 & disown
          exit
      end


      function rebuild
          # Capture previous system state
          set -l old_system (readlink /run/current-system)
          set -l update_requested 0
          set -l show_trace 0
          set -l rebuild_args
          cd $HOME

          # Parse arguments
          for arg in $argv
              if [ "$arg" = "--update" ]
                  set update_requested 1
                  echo "Updating flake..."
                  nix flake update --flake $HOME/nix || return 1
              else if [ "$arg" = "--show-trace" ]
                  set show_trace 1
              else
                  set rebuild_args $rebuild_args $arg
              end
          end

          # Build/switch
          if contains "switch" $rebuild_args || contains "test" $rebuild_args
              echo "Building and activating..."
              if [ $show_trace -eq 1 ]
                  sudo nixos-rebuild $rebuild_args --flake $HOME/nix#edwin --show-trace || return 1
              else
                  sudo nixos-rebuild $rebuild_args --flake $HOME/nix#edwin || return 1
              end
              set new_system (readlink -f /run/current-system)
          else
              echo "Building..."
              if [ $show_trace -eq 1 ]
                  sudo nixos-rebuild build --flake $HOME/nix#edwin --show-trace || return 1
              else
                  sudo nixos-rebuild build --flake $HOME/nix#edwin || return 1
              end
              set new_system (readlink result)
          end

          # Only show diff if:
          # 1. --update was used, or
          # 2. The system actually changed
          if [ "$update_requested" -eq 1 ] || [ "$old_system" != "$new_system" ]
              nvd diff $old_system $new_system
          else
              echo "No changes detected."
          end
      end
    '';
    shellAbbrs = {
      rm = "rm -I";
      top = "htop";
      yamend = "yadm commit --amend --no-edit && yadm push -f";
      reconfig = "home-manager switch --flake $HOME/nix#edwin";
      df="df -h";
      dus="du -h --max-depth=1 | sort -hr";
      fc-list=''fc-list --format="%{family[0]}\n" | sort | uniq'';
      sortmusic=''cd ~/Music/ && stat --format="%W %n" * | sort -nr'';

      gpg-list="gpg --list-secret-keys --keyid-format LONG";
      gpg-backup="gpg -o private.gpg --export-options backup --export-secret-keys";
      gpg-restore="gpg --import-options restore --import private.gpg";

      rclone="rclone -P --transfers 45 --checkers 65";
      compresspdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dColorImageResolution=170 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf"; 
    };
  };
}
