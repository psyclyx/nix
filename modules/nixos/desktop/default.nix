{
  config,
  lib,
  pkgs,
  ...
}: let
  desktopCfg = config.psyclyx.desktop;
in {
  imports = [./sway.nix];
  options.psyclyx.desktop = {
    enable = lib.mkEnableOption ''
      Set up a graphical environment.
    '';
  };

  config =
    lib.mkIf desktopCfg.enable {
      services = {
        gvfs.enable = lib.mkDefault true;
        gnome.gnome-keyring = lib.mkDefault true;
      };
    };
}
