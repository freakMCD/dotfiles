{ pkgs, lib, inputs, ... }:

let
  steveRaw = "${inputs.stevenblack}/alternates/porn-social/hosts";

  # Filter WhatsApp section out of StevenBlack
  extrahostsfromsteve = pkgs.runCommand "filtered-stevenblack-hosts" {
    nativeBuildInputs = [ pkgs.gawk ];
  } ''
    awk '
      /^# *Whatsapp/ { skip=1; last_hdr=NR; next }
      /^# / {
        if (skip) {
          if (NR == last_hdr + 1) { last_hdr = NR; next }
          skip = 0
        }
      }
      !skip
    ' ${steveRaw} > $out
  '';

  manualBlockedDomains = [
    "allkpop.com"
    "sudoku.coach"
    "pcgamer.com"
    "steamdb.info"
    "fandom.com"
    "rateyourmusic.com"
    "albumoftheyear.org"
    "speedrun.com"
    "steamcommunity.com"
  ];

  manualHosts = builtins.concatStringsSep "\n" (lib.concatMap (d: [
    "0.0.0.0 ${d}"
    ":: ${d}"
    "0.0.0.0 www.${d}"
    ":: www.${d}"
  ]) manualBlockedDomains);
in
{
  networking = {
    # Use external DNS directly (no local resolver)
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # Combine StevenBlack + manual blocked domains
  };
}

