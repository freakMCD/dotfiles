{
  # Enable and configure systemd-resolved
  services.resolved = {
    enable = true;
    fallbackDns = [];
    extraConfig = ''
      DNSOverTLS=yes
      LLMNR=no
    '';
  };

  networking.nameservers = [ 
      "45.90.28.0#4457ba.dns.nextdns.io"
      "2a07:a8c0::#4457ba.dns.nextdns.io"
      "45.90.30.0#4457ba.dns.nextdns.io"
      "2a07:a8c1::#4457ba.dns.nextdns.io"
  ];
}
