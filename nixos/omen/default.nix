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

  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

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
  services.fwupd.enable = true;
  programs.light.enable = true;
  hardware.pulseaudio.enable = true;
  services.hardware.bolt.enable = true;
  services.interception-tools = {
    enable = true;
    plugins = [pkgs.interception-tools-plugins.caps2esc];
    udevmonConfig = lib.mkDefault ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
  services.greetd = {
    enable = true;
    settings = {
      vt = 2;
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --remember --asterisks --cmd sway";
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
