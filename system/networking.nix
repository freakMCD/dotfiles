{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = true;
      DNS = [
        "45.90.28.0#4457ba.dns.nextdns.io"
        "2a07:a8c0::#4457ba.dns.nextdns.io"
        "45.90.30.0#4457ba.dns.nextdns.io"
        "2a07:a8c1::#4457ba.dns.nextdns.io"
      ];
    };
  };
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
}

