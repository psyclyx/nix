{ inputs, ... }:
{
  system.stateVersion = "24.05";
  networking.hostName = "sigil";
  time.timeZone = "America/Los_Angeles";
  imports = [
    ../../modules/nixos/nixpkgs.nix
    ../../modules/nixos/module.nix
    ../../modules/nixos/system/home-manager.nix

    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];

  psyclyx = {
    graphics = {
      fonts = {
        enable = true;
      };
    };

    programs = {
      steam = {
        enable = true;
      };
      sway = {
        enable = true;
      };
    };

    services = {
      autoMount = {
        enable = true;
      };
      gnome-keyring = {
        enable = true;
      };
      greetd = {
        enable = true;
      };
      home-assistant = {
        enable = true;
      };
      openssh = {
        enable = true;
      };
      printing = {
        enable = true;
      };
      tailscale = {
        enable = true;
        exitNode = true;
      };
    };

    system = {
      sudo = {
        enable = true;
      };
      virtualization = {
        enable = true;
      };
    };
  };
}
