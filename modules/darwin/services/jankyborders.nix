{ config, lib, pkgs, ... }:

let
  colors = import ../../home/themes/angel.nix { inherit lib; };
  theme = colors.colorUtils.mkTheme "jankyborders";
in {
  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;
    
    # Use the focused/active colors from our theme
    active_color = theme.wm.focused.border;
    inactive_color = theme.wm.unfocused.border;
    
    # Styling
    width = 4.0;
    style = "round";  # or "square" if you prefer
    order = "above";  # or "below" if you prefer
    blur_radius = 2.0;
    
    # Optional: Enable HiDPI if you're using a retina display
    hidpi = true;  # Set to true for retina displays
    
    # Optional: Background color (leave empty for no background)
    background_color = "";
  };
}
