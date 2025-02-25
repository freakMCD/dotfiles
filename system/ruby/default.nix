{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      html2rss = prev.bundlerApp {
        pname = "html2rss";
        exes = ["html2rss"];
        gemdir = ./.;
      };
    })
  ];

  environment.systemPackages = [ pkgs.html2rss ];
}
