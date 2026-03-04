{
  services.nextdns = {
    enable = true;
    arguments = [
      "-config" "4457ba"
      "-report-client-info"
    ];
  };
  networking.nameservers = ["127.0.0.1" "::1"];
  networking.useDHCP = true;
}

