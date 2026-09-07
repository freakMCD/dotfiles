{ ... }:

{
  # Normal DNS: filtered through NextDNS.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      Domains = [ "~." ];
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

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    useDHCP = false;
    dhcpcd.enable = false;
  };

  # Unfiltered DNS
  services.dnsproxy = {
    enable = true;

    settings = {
      listen-addrs = [ "127.0.0.2" ];
      listen-ports = [ 53 ];

      upstream = [
        "https://1.1.1.1/dns-query"
        "https://1.0.0.1/dns-query"
      ];
    };
  };
}
