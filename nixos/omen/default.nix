{
  pkgs,
  lib,
  ...
}: let
  userName = "psyc";
  userHome = "/home/psyc";
in {
  imports = [
    ./hardware.nix
  ];

  system.stateVersion = "24.05"; # Likely don't want to ever change this

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "omen";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "America/Los_Angeles";

  security.polkit.enable = true;

  services.printing.enable = true;
  services.libinput.enable = true;
  services.interception-tools.enable = true;
  services.fwupd.enable = true;
  programs.light.enable = true;
  hardware.pulseaudio.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -- time --cmd sway";
      };
      user = "greeter";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager"]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.psyc = ../../home/nixos.nix;
}
