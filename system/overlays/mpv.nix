{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (final.fetchurl {
            url = "https://github.com/mpv-player/mpv/commit/70894ae0390cf20edac0e68de72ab26725520416.patch";
            hash = "sha256-awCyEXTkEGgrY8f8DvI//YEziENeRE5fOpwzJTTmZ9o=";
          })
        ];
      });
    })
  ];
}
