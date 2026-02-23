{ pkgs, ... }: 
let
  rcloneOpts = pkgs.lib.strings.concatStringsSep " " [
    "--transfers 8"
    "--checkers 16"
    "-P"
    "--retries 3"
    "--retries-sleep 10s"
    "--fast-list"
    "--timeout 300s"
    "--contimeout 60s"
    "--exclude=.auxfiles/**"
    "--exclude=screenshots/**"
    "--log-level INFO"
    "--size-only"
  ];
in
{
home.packages = with pkgs; [
    (writeShellScriptBin "open_file" ''
          selected_file=$(fzf --delimiter / --with-nth 4..)

          # Open the selected file using nohup and redirect output to nohup.out
          nohup xdg-open "$selected_file" >/dev/null 2>&1 &
          sleep 0.2
          # Close the terminal
          exit 
    '')

    (writeShellScriptBin "syncFiles" ''
      cd "$HOME"

      echo "Starting sync to drive..."
      rclone ${rcloneOpts} sync Documents drive:BACKUP/Documents
      rclone ${rcloneOpts} sync MathCareer drive:BACKUP/MathCareer

      echo "Starting sync to mega..."
      rclone ${rcloneOpts} sync Documents mega:Documents
      rclone ${rcloneOpts} sync MediaHub mega:MediaHub
      rclone ${rcloneOpts} sync MathCareer mega:MathCareer
    '')

    (writeShellScriptBin "syncMusic" ''
      cd "$HOME"
      
      echo "Syncing Music to mega..."
      rclone ${rcloneOpts} sync Music drive:Music
    '')
];
}

