{pkgs, config, lib, ...}:
let 
  defaultNameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];
in
{

networking = {
  nameservers = [ "127.0.0.1" ];
  stevenBlackHosts = {
    enableIPv6 = true;
    blockPorn = true;
  };
  extraHosts = builtins.readFile ./hosts/social/hosts;
};

services.dnsmasq = {
    enable = true;
    settings = {
      domain-needed = true;
      bogus-priv = true;
      server = defaultNameservers;
      cache-size = 2000;
   };
};


}
