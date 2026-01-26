{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      fallbackDns = [];
      DNSOverTLS = true;
      LLMNR = false;
      MulticastDNS = false;
      DNS = [
        "45.90.28.0#4457ba.dns.nextdns.io"
        "2a07:a8c0::#4457ba.dns.nextdns.io"
        "45.90.30.0#4457ba.dns.nextdns.io"
        "2a07:a8c1::#4457ba.dns.nextdns.io"
      ];
    };
  };
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  networking.useNetworkd = true;
  systemd.network.networks."40-wired" = {
    matchConfig = {Type = "ether";};
    DHCP = "yes";
    networkConfig = {
      IPv6PrivacyExtensions = "yes";
    };
  };
}

