{
  inputs,
  modulesPath,
  ...
}: let
in {
  system.stateVersion = "24.05";
  time.timeZone = "America/Los_Angeles";
  imports = [
    ../../modules/platform/nixos/base
    ./users.nix
    ./network.nix
    ./hardware.nix
    ./filesystems.nix
  ];
  services.openssh.ports = [17891];
  boot.loader.systemd-boot.enable = true;
}
