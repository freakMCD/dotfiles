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
    (writeShellScriptBin "syncfiles" ''
      cd "$HOME"

      echo "Starting sync to drive..."
      rclone ${rcloneOpts} sync Documents drive:Backups/Documents
      rclone ${rcloneOpts} sync MathCareer drive:Backups/MathCareer

      echo "Starting sync to mega..."
      rclone ${rcloneOpts} sync Documents mega:Documents
      rclone ${rcloneOpts} sync MediaHub mega:MediaHub
      rclone ${rcloneOpts} sync MathCareer mega:MathCareer
    '')
];
}

