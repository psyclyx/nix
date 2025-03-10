{
  config,
  lib,
  pkgs,
  ...
}: let
  desktopCfg = config.psyclyx.desktop;
in {
  imports = [./sway.nix ./tuigreet.nix];
  options.psyclyx.desktop = {
    enable = lib.mkEnableOption ''
      Set up a graphical environment.
    '';
  };

  config = lib.mkIf desktopCfg.enable {
    psyclyx.desktop.sway.enable = lib.mkDefault true;
    services = {
      gvfs.enable = lib.mkDefault true;
      gnome.gnome-keyring = lib.mkDefault true;

      tuigreet = {
        time = true;
        user-menu = true;
        remember = true;
        asterisks = true;
        cmd = "${pkgs.sway}/bin/sway";
      };

      greetd = {
        enable = lib.mkDefault true;
        vt = lib.mkDefault 2;
        settings = {
          default_session.command = config.services.greetd.tuigreet.command;
        };
      };
    };
  };
}
