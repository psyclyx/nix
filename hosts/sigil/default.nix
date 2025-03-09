{inputs, ...}: let
in {
  system.stateVersion = "24.05";
  time.timeZone = "America/Los_Angeles";
  imports = [
    ../../modules/nixos/tailscale.nix
    ../../modules/nixos/base
    ../../modules/nixos/physical
    ../../modules/nixos/graphical
    ../../modules/nixos/services/printing.nix
    ../../modules/nixos/programs/adb.nix
    ../../modules/nixos/programs/steam.nix

    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
    ./secrets.nix
    #./services/rtorrent.nix
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
