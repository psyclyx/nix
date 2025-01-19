{inputs, ...}: let
  inherit (inputs) disko;
in {
  system.stateVersion = "24.05";
  imports = [
    disko.nixosModules.disko
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
    ../../modules/nixos/system/console.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/nix.nix
    ../../modules/nixos/system/time.nix
    ../../modules/nixos/system/security.nix
    ../../modules/nixos/programs/zsh.nix
    ../../modules/nixos/services/openssh.nix
  ];

  services.soju.enable = true;
}
