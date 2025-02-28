# ipv6 2606:7940:32:26::/120
# gw 2606:7940:32:26::1
# ipv4 199.255.18.171/32
# gw 2606:7940:32:26::10
{
  config,
  pkgs,
  ...
}: let
  isp = "2606:7940:32:26";
in {
  networking.useNetworkd = false;
  networking.useDHCP = false;

  # Enable systemd-networkd
  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;

    # Define the bond device
    netdevs."10-bond0" = {
      netdevConfig = {
        Name = "bond0";
        Kind = "bond";
      };
      bondConfig = {
        Mode = "balance-alb";
        MIIMonitorSec = "100ms";
        TransmitHashPolicy = "layer3+4";
        FailOverMACPolicy = "active";
      };
    };

    # Configure the physical interfaces
    networks."20-eth0" = {
      matchConfig.Name = "ens1f0np0";
      networkConfig = {
        Bond = "bond0";
        DHCP = "no";
      };
    };

    networks."20-eth1" = {
      matchConfig.Name = "ens1f1np1";
      networkConfig = {
        Bond = "bond0";
        DHCP = "no";
      };
    };

    networks."30-bond0" = {
      matchConfig.Name = "bond0";
      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
        RequiredForOnline = "carrier";
        LinkLocalAddressing = "no";
      };

      address = [
        "${isp}::10/128"
        "${isp}::11/128"
      ];

      routes = [
        {
          Gateway = "${isp}::1";
          Destination = "::/0";
        }
      ];

      dns = [
        "2606:4700:4700::1111" # Cloudflare IPv6 DNS
        "2001:4860:4860::8888" # Google IPv6 DNS
      ];
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;
  };
}
