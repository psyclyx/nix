{
  networking = {
    enableIPv6 = true;
    useNetworkd = true;
    useDHCP = false;
    dhcpcd.enable = false;
  };

  systemd.network = {
    enable = true;

    netdevs."25-br0" = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
    };

   networks."10-ens1f0np0" = {
      matchConfig = {
        Name = "ens1f0np0";
      };
      networkConfig = {
        Bridge = "br0";
      };
   };

   networks."11-ens1f1np1" = {
      matchConfig = {
        Name = "ens1f1np1";
      };
      networkConfig = {
        Bridge = "br0";
      };
   };

   networks."30-br0" = {
      matchConfig = {
        Name = "br0";
      };
      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = "no";
        LinkLocalAddressing = "ipv6";
      };
      address = [
        "2606:7940:32:26::10/120"
      ];
      routes = [
        { routeConfig = {
            Destination = "::/0";
            Gateway = "2606:7940:32:26::1";
          };
        }
{ routeConfig = {
            Destination = "0.0.0.0/0";
            Gateway = "2606:7940:32:26::1";
            GatewayOnLink = true;
          };
        }
      ];
      # DNS configuration
      dns = [
        "2001:4860:4860::8888"  # Google DNS
        "2001:4860:4860::8844"  # Google DNS alternate
      ];
      domains = [
        "~."  # Use these DNS servers for all domains
      ];
    };
  };

  networking.nameservers = [];  # Clear any global nameservers as we're setting them in networkd

  # Disable the firewall completely for now
  networking.firewall = {
    enable = false;
  };
}
