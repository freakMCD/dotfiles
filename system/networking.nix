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
  extraHosts =
    let
      hostsFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        sha256 = "14vwnqamh48fqjkc0860wfdynqzn8r6dnpppndhmn6669cvb89qx";
      };
    in
    builtins.readFile "${hostsFile}";
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
