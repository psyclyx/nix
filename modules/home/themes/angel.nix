{lib}: let
  baseColors = {
    background = "FFFFFF";
    background_alt = "F2F2F2";
    foreground = "295573";
    foreground_alt = "6C6C6C";
    border = "B0D0E4";
    border_active = "295573";

    terminal = {
      black = "445B70";
      red = "B79574";
      green = "93A9BE";
      yellow = "CEB293";
      blue = "295573";
      magenta = "B0D0E4";
      cyan = "93A9BE";
      white = "F2F2F2";

      bright_black = "6C6C6C";
      bright_red = "CEB293";
      bright_green = "B0D0E4";
      bright_yellow = "DFC4A7";
      bright_blue = "5B87A5";
      bright_magenta = "C4E4F8";
      bright_cyan = "A7BDD2";
      bright_white = "FFFFFF";
    };

    wm = {
      focused = {
        border = "295573";
        background = "B0D0E4";
        text = "295573";
        indicator = "93A9BE";
      };

      unfocused = {
        border = "6C6C6C";
        background = "F2F2F2";
        text = "6C6C6C";
        indicator = "CEB293";
      };

      urgent = {
        border = "B79574";
        background = "CEB293";
        text = "295573";
        indicator = "B79574";
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
      withAlpha = alpha: hex: let
        a = lib.toHexString (builtins.floor (alpha * 255));
      in
        (
          if (builtins.stringLength a) == 1
          then "0${a}"
          else a
        )
        + hex;

      rgb = hex: let
        c = toRGB hex;
      in "rgb(${toString c.r}, ${toString c.g}, ${toString c.b})";

      rgba = alpha: hex: let
        c = toRGB hex;
      in "rgba(${toString c.r}, ${toString c.g}, ${toString c.b}, ${toString alpha})";
    };

    compose = fs: hex: builtins.foldl' (acc: f: f acc) hex fs;

    mkTheme = transforms: let
      formatValue = value:
        if builtins.isAttrs value
        then lib.mapAttrs (name: val: formatValue val) value
        else compose transforms value;
    in
      formatValue baseColors;
    mkThemeEnv = transforms: let
      formatValue = prefix: value:
        if builtins.isAttrs value
        then
          lib.concatMapAttrs
          (name: val:
            formatValue
            (
              if prefix == ""
              then name
              else "${prefix}_${name}"
            )
            val)
          value
        else {"THEME_${lib.toUpper prefix}" = compose transforms value;};
    in
      formatValue "" baseColors;
  };
in {
  inherit baseColors colorUtils;
}
