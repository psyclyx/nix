{
  pkgs,
  lib,
  ...
}: let
  colors = import ../../../home/themes/angel.nix {inherit lib;};
  themeEnv = with colors.colorUtils; mkThemeEnv [(transform.withAlpha 1.0) transform.withOx];
  transparentTheme = with colors.colorUtils; mkTheme [(transform.withAlpha 0.4) transform.withOx];

  aerospacePlugin = pkgs.writeShellApplication rec {
    name = "aerospace_plugin";
    text = builtins.readFile ./aerospace_plugin.sh;
    derivationArgs.buildInputs = with pkgs; [
      aerospace
      sketchybar
    ];

    runtimeInputs = derivationArgs.buildInputs;
    runtimeEnv = themeEnv;
  };

  clockPlugin = pkgs.writeShellApplication rec {
    name = "clock_plugin";
    text = builtins.readFile ./clock_plugin.sh;
    derivationArgs.buildInputs = with pkgs; [
      aerospace
      sketchybar
    ];

    runtimeInputs = derivationArgs.buildInputs;
  };

  batteryPlugin = pkgs.writeShellApplication rec {
    name = "battery_plugin";
    text = builtins.readFile ./battery.sh;
    derivationArgs.buildInputs = with pkgs; [
      aerospace
      sketchybar
      gnugrep
    ];

    runtimeInputs = derivationArgs.buildInputs;
  };

  rc = pkgs.writeShellApplication rec {
    name = "sketchybarrc";
    text = builtins.readFile ./sketchybarrc.sh;
    derivationArgs.buildInputs =
      (with pkgs; [
        aerospace
        sketchybar
        gnugrep
      ])
      ++ [
        aerospacePlugin
        clockPlugin
        batteryPlugin
      ];

    runtimeInputs = derivationArgs.buildInputs;
    runtimeEnv =
      themeEnv
      // {
        "BAR_BACKGROUND" = transparentTheme.background;
      };
  };
in {
  services.sketchybar = {
    enable = true;
    config = "sketchybarrc";
    extraPackages = [
      aerospacePlugin
      batteryPlugin
      clockPlugin
      pkgs.gnugrep
      rc
    ];
  };
}
