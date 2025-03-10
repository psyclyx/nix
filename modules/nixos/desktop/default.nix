{
  config,
  lib,
  pkgs,
  ...
}: let
  desktopCfg = config.psyclyx.desktop;
in {
  imports = [
    ./sway.nix
    ./tuigreet.nix
  ];
  options.psyclyx.desktop = {
    enable = lib.mkEnableOption ''
      Set up a graphical environment.
    '';
  };

  config = lib.mkIf desktopCfg.enable {
    environment.systemPackages = [pkgs.dbus];

    psyclyx.desktop.sway.enable = lib.mkDefault true;

    services = {
      gvfs.enable = lib.mkDefault true;
      gnome.gnome-keyring.enable = lib.mkDefault true;

      greetd = {
        tuigreet = {
          enable = true;
          time = true;
          user-menu = true;
          theme = {
            border = "red";
            text = "magenta";
          };
          remember = true;
          asterisks = true;
          cmd = "sway";
        };

        enable = lib.mkDefault true;
        vt = lib.mkDefault 2;
      };
    };
  };
}
