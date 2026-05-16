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

      function fmpc --description "Fuzzy MPD selector for The Stage"
          set -l folder "The Stage"

          set -l selection (
              mpc --format "%position%\t%artist%\t%title%\t%file%" playlist | \
              awk -F '\t' -v folder="$folder/" '
                  $4 ~ "^" folder {
                      file = $4
                      sub("^" folder, "", file)

                      artist = ($2 == "" ? "Unknown Artist" : $2)
                      title  = ($3 == "" ? file : $3)

                      printf "%s\t%s — %s\n", $1, artist, title
                  }
              ' | \
              fzf \
                  --query="$argv" \
                  --ansi \
                  --reverse \
                  --cycle \
                  --height=75% \
                  --border \
                  --prompt="🎵  " \
                  --pointer="▶" \
                  --marker="✓" \
                  --delimiter='\t' \
                  --with-nth=2 \
                  --nth=2 \
                  --tiebreak=index \
                  --bind='enter:accept' \
                  --select-1 \
                  --exit-0
          )

          test -z "$selection"; and return

          set -l position (string split \t -- $selection)[1]

          mpc -q play $position
      end

      function zipm
          if test (count $argv) -ne 1
              echo "Usage: zipm archive.zip"
              return 1
          end

          set -l archive $argv[1]

          set -l choice (
              printf "selected files\nall files\n" \
              | fzf --prompt="zip mode > "
          )

          switch $choice
              case "selected files"
                  set -l files (
                      fd --type f . \
                      | fzf --multi
                  )

                  if test -z "$files"
                      return 1
                  end

                  7z a $archive $files

              case "all files"
                  7z a $archive .

              case '*'
                  return 1
          end
      end

      function fe
          set -l files (fzf --delimiter / --with-nth 4.. --query="$argv" --multi --select-1 --exit-0 | string split0)
          if test -n "$files"
            eval $EDITOR $files
          end
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
              nvd diff $old_system $new_system | grep -E '^\[(U\*|R\.)'
          else
              echo "No changes detected."
          end
      end
    '';
    shellAbbrs = {
      windows10 = ''quickemu --vm windows-10.conf --public-dir ~/Share --mouse "virtio"'';
      rm = "rm -I";
      yamend = "yadm commit --amend --no-edit && yadm push -f";
      df="df -h";
      dus="du -h --max-depth=1 | sort -hr";
      fc-list=''fc-list --format="%{family[0]}\n" | sort | uniq'';

      gpg-list="gpg --list-secret-keys --keyid-format LONG";
      gpg-backup="gpg -o private.gpg --export-options backup --export-secret-keys";
      gpg-restore="gpg --import-options restore --import private.gpg";

      rclone="rclone -P --transfers 45 --checkers 65";
      compresspdf="gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dColorImageResolution=170 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf"; 
    };
  };
}
