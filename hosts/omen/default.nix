{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./users.nix
    ../../modules/nixos/programs
    ../../modules/nixos/services
    ../../modules/nixos/system
  ];
  services.resolved.enable = true;
  networking.useDHCP = true;
  networking.interfaces.tailscale0.useDHCP = false;
  services.tailscale = {enable = true;};
  networking.firewall.allowedUDPPorts = [41641];
  environment.systemPackages = [pkgs.tailscale];
}
