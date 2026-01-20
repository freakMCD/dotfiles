{ pkgs, ... }: 
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

(writeShellScriptBin "syncMega" ''
  RCLONE_OPTS="--transfers 8 --checkers 16 -P \
  --retries 3 --retries-sleep 10s \
  --fast-list \
  --timeout 300s --contimeout 60s \
  --exclude=auxfiles/** \
  --exclude=screenshots/** \
  --log-level INFO"

  cd ~
  rclone $RCLONE_OPTS sync Documents drive:BACKUP/Documents
  rclone $RCLONE_OPTS sync MediaHub drive:BACKUP/MediaHub
  rclone $RCLONE_OPTS sync MathCareer drive:BACKUP/MathCareer

  rclone $RCLONE_OPTS sync Documents mega:Documents
  rclone $RCLONE_OPTS sync MediaHub mega:MediaHub
  rclone $RCLONE_OPTS sync MathCareer mega:MathCareer
'')
];
}
