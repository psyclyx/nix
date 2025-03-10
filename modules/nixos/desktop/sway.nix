{
  config,
  lib,
  pkgs,
  ...
}: let
  desktopCfg = config.psyclyx.desktop;
in {
  options.psyclyx = {
    desktop.sway = {
      enable = lib.mkEnableOption ''
        Installs sway system wide.
        This includes global settings to make Sway play nice with the rest
        of the system, but doesn't set any configuration.
        TODO: get home-manager configuration module'd
      '';
    };
  };

  config = lib.mkIf desktopCfg.sway.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures = lib.mkDefault {
        base = true;
        gtk = true;
      };

      extraPackages = [
        pkgs.wl-clipboard
        pkgs.wtype
      ];

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        NIXOS_OZONE_WL=1
      '';
    };
  };
}
