{inputs, ...}: let
  inherit (inputs) disko;
in {
  system.stateVersion = "24.05";
  time.timeZone = "America/Los_Angeles";

  imports = [
    ../../modules/nixos/network
    ../../modules/nixos/base
    ../../modules/nixos/services/soju.nix

    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];
}
