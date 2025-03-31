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
          nohup mpv $argv & disown
          exit
      end

      function ttv
          nohup streamlink https://twitch.tv/"$argv" --title "{author} - {category}" --player=mpv --twitch-proxy-playlist=https://eu.luminous.dev,https://lb-eu.cdn-perfprod.com best & disown
          exit
      end

      function rebuild
        sudo nixos-rebuild build --flake $HOME/nix#edwin && nvd diff /run/current-system result
      end

      function cheat
        curl cheat.sh/$argv
      end
    '';
    shellAbbrs = {
      rm = "rm -I";
      top = "htop";
      yamend = "yadm commit --amend --no-edit && yadm push -f";
      reswitch = "sudo nixos-rebuild --flake $HOME/nix#edwin switch";
      retest = "sudo nixos-rebuild --flake $HOME/nix#edwin test --fast";
      reconfig = "home-manager switch --flake $HOME/nix#edwin";
      df="df -h";
      dus="du -h --max-depth=1 | sort -hr";
      mp3dl=''yt-dlp --restrict-filenames --extract-audio --audio-format mp3 "https://www.youtube.com/playlist?list=WL" --cookies-from-browser firefox:~/.mozilla/firefox/'';
      litedlp="yt-dlp -f 'bestvideo[height<=720]+bestaudio/best'";
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
