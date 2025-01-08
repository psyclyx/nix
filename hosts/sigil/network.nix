{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.resolved.enable = true;
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  services.tailscale = {enable = true;};
  networking.firewall.allowedTCPPorts = [8123 3000 51103];
  environment.systemPackages = [pkgs.tailscale];
  networking.firewall.allowedUDPPorts = [41641 51820 6881 3000 51103];

  vpnNamespaces.wg-mvd = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."wg-mullvad.conf".path;
    openVPNPorts = [
      {
        port = 51103;
        protocol = "both";
      }
      {
        port = 6881;
        protocol = "both";
      }
    ];
  };
}
