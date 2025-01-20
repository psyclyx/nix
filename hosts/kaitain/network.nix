{
  ...
}: {
  services.resolved.enable = true;
  networking.useNetworkd = true;
  networking.useDHCP = true;
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [22];
}
