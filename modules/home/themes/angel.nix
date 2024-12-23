# Color utilities for the ethereal watercolor theme
{ lib }:
let
  # Base colors in hex
  baseColors = {
    # Core colors
    background = "ffffff";
    background_alt = "f2f2f2";
    foreground = "295573";
    foreground_alt = "6c6c6c";
    border = "b0d0e4";
    border_active = "295573";

    # Terminal colors
    terminal = {
      black = "445b70";
      red = "b79574";
      green = "93a9be";
      yellow = "ceb293";
      blue = "295573";
      magenta = "b0d0e4";
      cyan = "93a9be";
      white = "f2f2f2";
      
      bright_black = "6c6c6c";
      bright_red = "ceb293";
      bright_green = "b0d0e4";
      bright_yellow = "dfc4a7";
      bright_blue = "5b87a5";
      bright_magenta = "c4e4f8";
      bright_cyan = "a7bdd2";
      bright_white = "ffffff";
    };

    # Window manager colors
    wm = {
      focused = {
        border = "295573";    # Active window border
        background = "b0d0e4"; # Active window title bg
        text = "295573";      # Active window title text
        indicator = "93a9be"; # Active workspace indicator
      };
      unfocused = {
        border = "6c6c6c";    # Inactive window border
        background = "f2f2f2"; # Inactive window title bg
        text = "6c6c6c";      # Inactive window title text
        indicator = "ceb293"; # Inactive workspace indicator
      };
      urgent = {
        border = "b79574";    # Urgent window border
        background = "ceb293"; # Urgent window title bg
        text = "295573";      # Urgent window title text
        indicator = "b79574"; # Urgent workspace indicator
      };
    };
  };

  # Utility functions for color format conversion
  colorUtils = rec {
    # Convert hex to RGB components
    hexToRGB = hex: {
      r = lib.toInt "16" (lib.substring 0 2 hex);
      g = lib.toInt "16" (lib.substring 2 2 hex);
      b = lib.toInt "16" (lib.substring 4 2 hex);
    };

    # Generate color in various formats
    formatColor = hex: {
      jankyborders = "0xff${hex}";
      sketchybar = "0xff${hex}";
      hex = "#${hex}";
      rgb = let c = colorUtils.hexToRGB hex;
      in "rgb(${toString c.r}, ${toString c.g}, ${toString c.b})";
      argb = let c = colorUtils.hexToRGB hex;
      in "rgba(${toString c.r}, ${toString c.g}, ${toString c.b}, 1.0)";
      xrdb = "#${hex}";
      css = "#${hex}";
      i3 = "#${hex}";
      sway = "#${hex}";
      polybar = "#${hex}";
    };

    # Generate the full theme in specified format
    mkTheme = format: let
      formatValue = value:
        if builtins.isAttrs value
        then lib.mapAttrs (name: val: formatValue val) value
        else (formatColor value).${format};
    in formatValue baseColors;

    # Generate alpha variants
    withAlpha = color: alpha: let
      c = hexToRGB color;
    in "rgba(${toString c.r}, ${toString c.g}, ${toString c.b}, ${toString alpha})";

    # Get a flat set of WM colors in specified format
    mkWMTheme = format: let
      theme = mkTheme format;
    in {
      focused = theme.wm.focused;
      unfocused = theme.wm.unfocused;
      urgent = theme.wm.urgent;
    };
  };

in {
  inherit baseColors colorUtils;
}
