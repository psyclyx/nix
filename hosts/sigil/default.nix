{inputs, ...}: let
  inherit (inputs) disko;
in {
  system.stateVersion = "24.05";
  imports = [
    disko.nixosModules.disko
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/programs/sway.nix
    ../../modules/nixos/programs/zsh.nix
    ../../modules/nixos/services/devmon.nix
    ../../modules/nixos/services/fwupd.nix
    ../../modules/nixos/services/gnome-keyring.nix
    ../../modules/nixos/services/greetd.nix
    ../../modules/nixos/services/gvfs.nix
    ../../modules/nixos/services/udisks2.nix
    ../../modules/nixos/system/console.nix
    ../../modules/nixos/system/fonts.nix
    ../../modules/nixos/system/home-manager.nix
    ../../modules/nixos/system/locale.nix
    ../../modules/nixos/system/nix.nix
    ../../modules/nixos/system/security.nix
    ../../modules/nixos/system/time.nix
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];

  programs.sway.extraOptions = [
    "--unsupported-gpu"
  ];
}
