{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.psyclyx.programs.hyprland;
in
{
  options.psyclyx.programs.hyprland.enable = lib.mkEnableOption "Hyprland config";
  config = lib.mkIf cfg.enable {
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.wofi.enable = true;

    services.hyprpaper.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      systemd.enable = false;
      portalPackage = null;
      settings = {
        exec-once = [ "waybar -c ~/.config/waybar/hyprland.json" ];
        monitor = [
          "eDP-1, highres, 0x0, 1"
        ];
        # bezier = [
        #   "default, 0.12, 0.92, 0.08, 1.0"
        #   "wind, 0.12, 0.92, 0.08, 1.0"
        #   "overshot, 0.18, 0.95, 0.22, 1.03"
        #   "linear, 1, 1, 1, 1"
        # ];
        bezier = [
          "wind, 0.05, 0.85, 0.03, 0.97"
          "winIn, 0.07, 0.88, 0.04, 0.99"
          "winOut, 0.20, -0.15, 0, 1"
          "liner, 1, 1, 1, 1"
          "md3_standard, 0.12, 0, 0, 1"
          "md3_decel, 0.05, 0.80, 0.10, 0.97"
          "md3_accel, 0.20, 0, 0.80, 0.08"
          "overshot, 0.05, 0.85, 0.07, 1.04"
          "crazyshot, 0.1, 1.22, 0.68, 0.98"
          "hyprnostretch, 0.05, 0.82, 0.03, 0.94"
          "menu_decel, 0.05, 0.82, 0, 1"
          "menu_accel, 0.20, 0, 0.82, 0.10"
          "easeInOutCirc, 0.75, 0, 0.15, 1"
          "easeOutCirc, 0, 0.48, 0.38, 1"
          "easeOutExpo, 0.10, 0.94, 0.23, 0.98"
          "softAcDecel, 0.20, 0.20, 0.15, 1"
          "md2, 0.30, 0, 0.15, 1"
          "OutBack, 0.28, 1.40, 0.58, 1"
          "easeInOutCirc, 0.78, 0, 0.15, 1"
        ];
        animation = [

          "border, 1, 1.6, liner"
          "borderangle, 1, 82, liner, loop"
          "windowsIn, 1, 3.2, winIn, slide"
          "windowsOut, 1, 2.8, easeOutCirc"
          "windowsMove, 1, 3.0, wind, slide"
          "fade, 1, 1.8, md3_decel"
          "layersIn, 1, 1.8, menu_decel, slide"
          "layersOut, 1, 1.5, menu_accel"
          "fadeLayersIn, 1, 1.6, menu_decel"
          "fadeLayersOut, 1, 1.8, menu_accel"
          "workspaces, 1, 4.0, menu_decel, slide"
          "specialWorkspace, 1, 2.3, md3_decel, slidefadevert 15%"
        ];
        # animation = [
        #   "windows, 1, 5, wind, popin 60%"
        #   "windowsIn, 1, 6, overshot, popin 60%"
        #   "windowsOut, 1, 4, overshot, popin 60%"
        #   "windowsMove, 1, 4, overshot, slide"
        #   "layers, 1, 4, default, popin"
        #   "fadeIn, 1, 7, default"
        #   "fadeOut, 1, 7, default"
        #   "fadeSwitch, 1, 7, default"
        #   "fadeShadow, 1, 7, default"
        #   "fadeDim, 1, 7, default"
        #   "fadeLayers, 1, 7, default"
        #   "workspaces, 1, 5, overshot, slidevert"
        #   "border, 1, 1, linear"
        #   "borderangle, 1, 24, linear, loop"
        # ];
        general = {
          gaps_in = 8;
          gaps_out = 12;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
        };
        decoration = {
          shadow.enabled = false;
          rounding = 10;
          inactive_opacity = 0.75;

          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
        };
        layerrule = [ "blur,waybar" ];
        bind = [
          "SUPER, o, exec, ${pkgs.alacritty}/bin/alacritty"
          "SUPER, d, exec, wofi --show drun -I --width 28%"
          "SUPER SHIFT, E, exec, uwsm stop"
          "SUPER, Q, killactive,"
          "SUPER, F, fullscreen,"
          "SUPER, M, togglegroup,"
          "SUPER SHIFT, N, changegroupactive, f"
          "SUPER SHIFT, P, changegroupactive, b"
          "SUPER, R, togglesplit,"
          "SUPER, T, togglefloating,"

          "SUPER, h, movefocus, l"
          "SUPER, j, movefocus, d"
          "SUPER, k, movefocus, u"
          "SUPER, l, movefocus, r"

          "SUPER SHIFT, h, movewindow, l"
          "SUPER SHIFT, j, movewindow, d"
          "SUPER SHIFT, k, movewindow, u"
          "SUPER SHIFT, l, movewindow, r"

        ]
        ++ (builtins.concatLists (
          builtins.genList (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "SUPER, ${ws}, workspace, ${toString (x + 1)}"
              "SUPER SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          ) 10
        ));
      };
    };
  };
}
