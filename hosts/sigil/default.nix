{inputs, ...}: let
  inherit (inputs) disko sops-nix vpn-confinement;
in {
  system.stateVersion = "24.05";
  imports = [
    disko.nixosModules.disko
    sops-nix.nixosModules.sops
    vpn-confinement.nixosModules.default
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/programs/steam.nix
    ../../modules/nixos/programs/sway.nix
    ../../modules/nixos/programs/zsh.nix
    ../../modules/nixos/services/devmon.nix
    ../../modules/nixos/services/fwupd.nix
    ../../modules/nixos/services/gnome-keyring.nix
    ../../modules/nixos/services/greetd.nix
    ../../modules/nixos/services/gvfs.nix
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
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
    ./secrets.nix
    ./services/rtorrent.nix
  ];

  programs.sway.extraOptions = [
    "--unsupported-gpu"
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "zha"
      "ios"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };
}
