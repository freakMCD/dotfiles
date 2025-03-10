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
  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = defaultNameservers;
      bootstrapDns = defaultNameservers;
      blocking = {
        denylists = {
          stevenBlack = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
          ];
        };
        allowlists = {
          stevenBlack= [
            ''
              web.whatsapp.com
              *.whatsapp.net
            ''
          ];
        };
        clientGroupsBlock = {
          default = [ "stevenBlack" ];
        };
      };
    };
  };

  networking = {
    nameservers = ["127.0.0.1"];  # Use Blocky as the DNS resolver
    networkmanager = {
      enable = true;
      dns = "none";  # Disable NetworkManager's built-in DNS
    };
  };
}
