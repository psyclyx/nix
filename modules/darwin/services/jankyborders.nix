{
  lib,
  pkgs,
  ...
}: let
  colors = import ../../home/themes/angel.nix {inherit lib;};
  theme = with colors.colorUtils; mkTheme [(transform.withAlpha 0.9) transform.withOx];
in {
  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;

    active_color = builtins.trace theme.wm.focused.border theme.wm.focused.border;
    inactive_color = theme.wm.unfocused.border;

    width = 12.0;
    blur_radius = 4.0;
    style = "round";
    order = "below";

    hidpi = false;

    background_color = "";
  };
}
