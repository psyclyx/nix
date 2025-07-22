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
        general = {
          gaps_in = 6;
          gaps_out = 4;
          border_size = 1;
        };
        decoration = {
          rounding = 8;
        };
        bind = [
          "SUPER, o, exec, ${pkgs.alacritty}/bin/alacritty"
          "SUPER, d, exec, wofi --show drun -I --width 28%"
          "SUPER SHIFT, E, exec, pkill Hyprland"
          "SUPER, Q, killactive,"
          "SUPER, F, fullscreen,"
          "SUPER, G, togglegroup,"
          "SUPER SHIFT, N, changegroupactive, f"
          "SUPER SHIFT, P, changegroupactive, b"
          "SUPER, R, togglesplit,"
          "SUPER, T, togglefloating,"
          "SUPER, P, pseudo,"

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
