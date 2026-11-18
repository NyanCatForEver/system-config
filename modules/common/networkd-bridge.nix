{
  systemd.network = {
    netdevs."25-br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
      MACAddress = "none";
    };
    links."25-br0" = {
      matchConfig.OriginalName = "br0";
      linkConfig.MACAddressPolicy = "none";
    };
    networks."25-br0-enp1s0" = {
      matchConfig.Name = "enp1s0";
      networkConfig.Bridge = "br0";
    };
    networks."25-br0" = {
      matchConfig.Name = "br0";
      linkConfig.RequiredForOnline = "routable";
      networkConfig.DHCP = "yes";
    };
  };
}
