{ inputs, pkgs, ... }:
{
  system.stateVersion = "25.05";
  networking.hostName = "omen";
  time.timeZone = "America/Los_Angeles";
  imports = [
    ../../../modules/nixos/nixpkgs.nix
    ../../../modules/nixos/module.nix
    ../../../modules/nixos/system/home-manager.nix
    inputs.stylix.nixosModules.stylix
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];

  stylix = {
    enable = true;
    #  base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-terminal-light.yaml";
    image = ../../wallpapers/2x-homura-clocks.png;
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSans Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.noto;
        name = "Aporetic Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  psyclyx = {
    programs = {
      sway = {
        enable = true;
      };
      hyprland = {
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
      locate = {
        enable = true;
        users = [ "psyc" ];
      };
      openssh = {
        enable = true;
      };
      kanata = {
        enable = true;
      };
      printing = {
        enable = true;
      };
      tailscale = {
        enable = true;
      };
    };
    system = {
      fonts = {
        enable = false;
      };
      sudo = {
        enable = true;
      };
    };
  };
}
