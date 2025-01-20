{inputs, ...}: let
  inherit (inputs) disko sops-nix vpn-confinement;
in {
  system.stateVersion = "24.05";
  imports = [
    sops-nix.nixosModules.sops
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/programs/zsh.nix
    ../../modules/nixos/services/openssh.nix
    ../../modules/nixos/services/udisks2.nix
    ../../modules/nixos/system/console.nix
    ../../modules/nixos/system/fonts.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/nix.nix
    ../../modules/nixos/system/security.nix
    ../../modules/nixos/system/time.nix
    ./boot.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];
  isoImage.makeUsbBootable = true;
  isoImage.isoName = "kaitainTest.iso";
}
