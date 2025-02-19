# ipv6 2606:7940:32:26::/120
# gw 2606:7940:32:26::1
# ipv4 199.255.18.171/32
# gw 2606:7940:32:26::10
{
  config,
  pkgs,
  ...
}: {
  networking = {
    useDHCP = false;

    defaultGateway6 = {
      address = "2606:7940:32:26::1";
      interface = "bond0";
    };

    bonds.bond0 = {
      interfaces = ["ens1f0np0" "ens1f1np1"];
      driverOptions = {
        mode = "802.3ad";
        miimon = "100";
        lacp_rate = "fast";
        xmit_hash_policy = "layer3+4";
      };
    };

    interfaces.bond0 = {
      useDHCP = false;
      ipv6 = {
        addresses = [
          {
            address = "2606:7940:32:26::10";
            prefixLength = 120;
          }
        ];
      };
    };

    interfaces.eno2 = {
      ipv6 = {
        addresses = [
          {
            address = "2606:7940:32:26::11";
            prefixLength = 120;
          }
        ];
      };
    };

    firewall = {
      enable = true;
      interfaces = {
        bond0.allowedTCPPorts = [
          17891
          443
          80
        ];
      };
    };
  };
}
