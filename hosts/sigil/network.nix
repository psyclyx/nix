{pkgs,...}: {
  services.resolved.enable = true;
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  services.tailscale = { enable = true; };
  networking.firewall.allowedUDPPorts = [ 41641 ];
  environment.systemPackages = [ pkgs.tailscale ];
}
