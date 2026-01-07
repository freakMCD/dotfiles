{
  # Enable and configure systemd-resolved
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNS=45.90.28.0#4457ba.dns.nextdns.io
      DNS=2a07:a8c0::#4457ba.dns.nextdns.io
      DNS=45.90.30.0#4457ba.dns.nextdns.io
      DNS=2a07:a8c1::#4457ba.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };

  # Make resolved the primary resolver
  networking.nameservers = [ "127.0.0.1" "::1" ];
}
