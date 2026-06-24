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
          set -l old_system (readlink -f /run/current-system)

          if contains -- --update $argv
              echo "updating flake..."
              nix flake update --flake ~/nix
              or return 1
          end

          sudo nixos-rebuild switch --flake ~/nix#edwin
          or return 1

          if contains -- --update $argv
              nix store diff-closures $old_system /run/current-system
          end
      end
    '';
    shellAbbrs = {
      windows10 = ''quickemu --vm windows-10.conf --public-dir ~/Share --mouse "virtio"'';
      rm = "rm -I";
      df = "df -h";
      dus = "du -h --max-depth=1 | sort -hr";
      fc-list = ''fc-list --format="%{family[0]}\n" | sort | uniq'';

      gpg-list = "gpg --list-secret-keys --keyid-format LONG";
      gpg-backup = "gpg -o private.gpg --export-options backup --export-secret-keys";
      gpg-restore = "gpg --import-options restore --import private.gpg";

      yamend = "yadm commit --amend && yadm push -f";
      rclone = "rclone -P --transfers 45 --checkers 65";
      compresspdf = "gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dColorImageResolution=170 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=output.pdf"; 
    };
  };
}
