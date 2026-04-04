{ config, pkgs, ... }:

let
  ethtool = pkgs.ethtool;
in
{
  services.resolved = {
    enable = true;

    # Use systemd-resolved's global DNS servers instead of per-interface.
    domains = [ "~." ];

    settings.Resolve = {
      DNSOverTLS = true;
      FallbackDNS = [];
      DNS = [
        "45.90.28.0#4457ba.dns.nextdns.io"
        "2a07:a8c0::#4457ba.dns.nextdns.io"
        "45.90.30.0#4457ba.dns.nextdns.io"
        "2a07:a8c1::#4457ba.dns.nextdns.io"
      ];
    };
  };

  networking.nameservers = [ "127.0.0.1" "::1" ];

  # Enable NetworkManager
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Disable dhcpcd entirely
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
}
