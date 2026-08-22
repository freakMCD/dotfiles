{ pkgs, ... }:

{
  # Runtime dependencies for the mutable official yt-dlp nightly binary.
  # yt-dlp itself is installed in ~/.local/bin, outside the Nix store.
  home.packages = with pkgs; [
    ffmpeg
    deno
    atomicparsley
  ];
}
