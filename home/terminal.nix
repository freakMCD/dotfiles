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

      function yt-compat
        # Help message
        if test (count $argv) -eq 1 -a \( "$argv[1]" = "-h" -o "$argv[1]" = "--help" \)
          echo "Usage: yt_compat <url> <range>"
          echo 'Example: yt_compat https://www.youtube.com/watch?v=o9DhvbqYzns 48-90'
          echo "Note: The range is in seconds"
          return
        end

        if test (count $argv) -ne 2
            echo "Error: Incorrect usage. Run 'yt-compat --help' for instructions."
            return 1
        end

        set url $argv[1]
        set range $argv[2]
        set temp_name (mktemp -u ytwhatsappXXXX) # Generate a unique temporary filename prefix

        # Download the specified segment with yt-dlp
        yt-dlp --download-sections "*$range" -f "bestvideo[height<=720]+bestaudio/best" -o "$temp_name.%(ext)s" $url

        # Convert the downloaded file to a WhatsApp-compatible format
        set input_file (ls $temp_name.* | head -n 1)
        ffmpeg -i "$input_file" -c:v libx264 -profile:v baseline -level 3.0 -acodec aac -movflags +faststart -pix_fmt yuv420p output.mp4
        # Remove temp file
        rm "$input_file"
      end

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
          nohup streamlink https://twitch.tv/"$argv" --title "{title} [{author}]" --player=mpv --twitch-proxy-playlist=https://eu.luminous.dev,https://lb-eu.cdn-perfprod.com best & disown
          exit
      end

      function rebuild
        sudo nixos-rebuild build --flake $HOME/nix#edwin && nvd diff /run/current-system result
      end
    '';
    shellAbbrs = {
      rm = "rm -I";
      top = "htop";
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
