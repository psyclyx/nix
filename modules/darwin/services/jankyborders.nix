{ config, lib, pkgs, ... }:

let
  colors = import ../../home/themes/angel.nix { inherit lib; };
  theme = with colors.colorUtils; mkTheme [(transform.withAlpha 1.0) transform.withOx];
in {
  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;

    # Use the focused/active colors from our theme
    active_color = builtins.trace theme.wm.focused.border theme.wm.focused.border;
    inactive_color = theme.wm.unfocused.border;

    # Styling
    width = 8.0;
    style = "round";  # or "square" if you prefer
    order = "above";  # or "below" if you prefer

    # Optional: Enable HiDPI if you're using a retina display
    hidpi = false;  # Set to true for retina displays

    # Optional: Background color (leave empty for no background)
    background_color = "";
  };
}
