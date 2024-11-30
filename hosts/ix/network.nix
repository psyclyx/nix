{...}: {
  system.network = {
    enable = true;
    networks."30-wan" = {
      matchConfig.Name = "eth0";
      networkConfig.DHCP = "no";
      address = [
        "162.55.34.172"
        "2a01:4f8:c17:90e8::1"
      ];
    };
    routes = [
      {
        routeConfig = {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        };
      }
      {routeConfig.Gateway = "fe80::1";}
    ];
  };
}
