{
  pkgs,
  lib,
  ...
}: let
  colors = import ../../../home/themes/angel.nix {inherit lib;};
  themeEnv = with colors.colorUtils; mkThemeEnv [(transform.withAlpha 1.0) transform.withOx];
  aerospacePlugin = pkgs.writeShellApplication {
    name = "aerospace_plugin";
    text = builtins.readFile ./aerospace_plugin.sh;
    runtimeInputs = [pkgs.sketchybar];
    derivationArgs.buildInputs = [
      pkgs.aerospace
      pkgs.sketchybar
    ];
    runtimeEnv = themeEnv;
  };

  clockPlugin = pkgs.writeShellApplication {
    name = "clock_plugin";
    text = builtins.readFile ./clock_plugin.sh;
    derivationArgs.buildInputs = [
      pkgs.aerospace
      pkgs.sketchybar
    ];
    runtimeInputs = [pkgs.sketchybar];
  };

  batteryPlugin = pkgs.writeShellApplication {
    name = "battery_plugin";
    text = builtins.readFile ./battery.sh;
    derivationArgs.buildInputs = [
      pkgs.aerospace
      pkgs.sketchybar
      pkgs.gnugrep
    ];
    runtimeInputs = [pkgs.sketchybar pkgs.gnugrep ];
  };

  rc = pkgs.writeShellApplication {
    name = "sketchybarrc";
    text = builtins.readFile ./sketchybarrc.sh;
    derivationArgs.buildInputs = [
      pkgs.aerospace
      pkgs.sketchybar
      aerospacePlugin
      pkgs.gnugrep
      clockPlugin
      batteryPlugin
    ];
    runtimeInputs = [
      pkgs.aerospace
      pkgs.sketchybar
      pkgs.gnugrep
      aerospacePlugin
      batteryPlugin
      clockPlugin
    ];
    runtimeEnv = builtins.trace themeEnv themeEnv;
  };
in {
  services.sketchybar = {
    enable = true;
    extraPackages = [rc
      aerospacePlugin
      clockPlugin
      batteryPlugin
      pkgs.gnugrep
    ];
    config = ''
      printenv > /tmp/sk-env
      sketchybarrc 2> /tmp/sk-log
    '';
  };
}
