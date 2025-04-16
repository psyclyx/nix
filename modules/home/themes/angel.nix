{ lib }:
let
  white = "F7FBFF";

  blue_lighter = "AFC1E9";
  blue_light = "7C8BAC";
  blue = "404F72A";
  blue_dark = "212C47";
  blue_darker = "0A101D";

  red_lighter = "FFAD8F";
  red_light = "FF8B61";
  red = "DE6335";
  red_dark = "963815";
  red_darker = "351104";

  yellow_lighter = "FFE28F";
  yellow_light = "FFD661";
  yellow = "DEB335";
  yellow_dark = "967515";
  yellow_darker = "352804";

  magenta_lighter = "F488C3";
  magenta_light = "D8529B";
  magenta = "B42B76";
  magenta_dark = "79114A";
  magenta_darker = "2B0319";

  green_lighter = "87F199";
  green_light = "4ECF65";
  green = "29AA3F";
  green_dark = "107221";
  green_darker = "03290A";

  baseColors = rec {
    background = blue_darker;
    background_alt = blue_dark;
    foreground = blue_lighter;
    foreground_alt = blue_light;
    border = blue;
    border_active = blue_light;

    terminal = {
      black = blue_darker;
      red = red;
      green = green_dark;
      yellow = yellow;
      blue = blue;
      magenta = magenta;
      cyan = green_light;
      white = foreground;

      bright_black = blue_dark;
      bright_red = red_light;
      bright_green = green;
      bright_yellow = yellow_light;
      bright_blue = blue_light;
      bright_magenta = magenta_light;
      bright_cyan = green_lighter;
      bright_white = white;
    };

    wm = {
      focused = {
        border = border_active;
        background = background_alt;
        text = foreground;
        indicator = border_active;
      };

      unfocused = {
        border = border;
        background = background;
        text = foreground_alt;
        indicator = border;
      };

      urgent = {
        border = red_light;
        background = red_dark;
        text = foreground;
        indicator = red_light;
      };
    };
  };

  colorUtils = rec {
    toRGB = hex: {
      r = lib.toInt "16" (lib.substring 0 2 hex);
      g = lib.toInt "16" (lib.substring 2 2 hex);
      b = lib.toInt "16" (lib.substring 4 2 hex);
    };

    transform = {
      hex = hex: hex;
      withHash = hex: "#" + hex;
      withOx = hex: "0x" + hex;
      withAlpha =
        alpha: hex:
        let
          a = lib.toHexString (builtins.floor (alpha * 255));
        in
        (if (builtins.stringLength a) == 1 then "0${a}" else a) + hex;

      rgb =
        hex:
        let
          c = toRGB hex;
        in
        "rgb(${toString c.r}, ${toString c.g}, ${toString c.b})";

      rgba =
        alpha: hex:
        let
          c = toRGB hex;
        in
        "rgba(${toString c.r}, ${toString c.g}, ${toString c.b}, ${toString alpha})";
    };

    compose = fs: hex: builtins.foldl' (acc: f: f acc) hex fs;

    mkTheme =
      transforms:
      let
        formatValue =
          value:
          if builtins.isAttrs value then
            lib.mapAttrs (name: val: formatValue val) value
          else
            compose transforms value;
      in
      formatValue baseColors;
    mkThemeEnv =
      transforms:
      let
        formatValue =
          prefix: value:
          if builtins.isAttrs value then
            lib.concatMapAttrs (
              name: val: formatValue (if prefix == "" then name else "${prefix}_${name}") val
            ) value
          else
            { "THEME_${lib.toUpper prefix}" = compose transforms value; };
      in
      formatValue "" baseColors;
  };
in
{
  inherit baseColors colorUtils;
}
