let 
  defaultNameservers = [
    "9.9.9.9"
    "9.9.9.10"
    "9.9.9.11"
    "2620:fe::9"
    "2620:fe::10"
    "2620:fe::11"
  ];
in
{ 
  networking = {
    useDHCP = false;
    nameservers = defaultNameservers;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    stevenblack = {
      enable = true;
      block = ["fakenews" "social" "porn"];
    };
    extraHosts = ''
      0.0.0.0 twitch.tv www.twitch.tv gql.twitch.tv
      0.0.0.0 allkpop.com www.allkpop.com
    '';
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=no # This is handled by Avahi.
    '';
    domains = ["~."];
    fallbackDns = defaultNameservers;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

}
