{
  systemd.network = {
    enable = true;
    networks."89-ethernet" = {
      matchConfig = {
        Kind = "!*";
        Type = "ether";
      };
      networkConfig.DHCP = true;

      dhcpV4Config.UseDNS = false;
      dhcpV6Config.UseDNS = false;
      ipv6AcceptRAConfig.UseDNS = false;
    };
  };

  services.resolved.enable = true;

  networking.useDHCP = false;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
}
