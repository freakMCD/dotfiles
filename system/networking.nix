{pkgs, inputs, config, lib, ...}:
let
  defaultNameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];

  steveRaw = "${inputs.stevenblack}/alternates/porn-social/hosts";

  # Filters the StevenBlack hosts file to preserve WhatsApp functionality.
  extrahostsfromsteve = pkgs.runCommand "filtered-stevenblack-hosts" {
    nativeBuildInputs = [ pkgs.gawk ];
  } ''
    awk '
      # When we hit a removal header, start skipping and record its line number
      /^# *Whatsapp/ { skip=1; last_hdr=NR; next }

      # On any header while skipping:
      /^# / {
        if (skip) {
          # If it’s immediately adjacent to the last header, swallow it too
          if (NR == last_hdr + 1) {
            last_hdr = NR
            next
          }
          # Otherwise it’s the real next section—stop skipping
          skip = 0
        }
      }

      # Print only when not in skip mode
      !skip
    ' ${steveRaw} > $out
  '';

  # === Declarative manual blocks (edit this list in your Nix config) ===
  # Put domains here (no scheme, no path). Example: "allkpop.com"
  manualBlockedDomains = [
    "allkpop.com"
    "sudoku.coach"
    "pcgamer.com"
    "steamdb.info"
    "fandom.com"
    "rateyourmusic.com"
    "albumoftheyear.org"
    "speedrun.com"
  ];

  # produce dnsmasq address entries (wildcard) for both IPv4 and IPv6
  addrEntries = lib.concatLists (map (d: [
    ("/" + d + "/0.0.0.0")
    ("/" + d + "/::")
  ]) manualBlockedDomains);
in
{
  networking = {
    # ensure local resolver
    nameservers = [ "127.0.0.1" ];

    # keep the filtered StevenBlack hosts as /etc/hosts (exact host entries)
    extraHosts = builtins.readFile extrahostsfromsteve;
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      domain-needed = true;
      bogus-priv = true;
      server = defaultNameservers;
      cache-size = 2000;

      # wildcard answers: blocks domain and all subdomains, v4 + v6
      address = addrEntries;
    };
  };
}

