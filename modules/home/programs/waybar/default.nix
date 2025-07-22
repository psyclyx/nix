{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = import ../../nixos/colors.nix;
  cfg = config.psyclyx.programs.waybar;
  common = (import ./modules.nix) // {
    reload_style_on_change = true;
    layer = "bottom";
    position = "top";
    margin = "4px 4px";
    spacing = 8;
    padding = "4px 4px";
  };
  sway = common // {
    name = "sway";
    modules-left = [
      "idle_inhibitor"
      "sway/workspaces"
      "sway/scratchpad"
      "sway/mode"
    ];
    modules-center = [ "clock" ];
    modules-right = [
      "network"
      "backlight"
      "pulseaudio"
      "memory"
      "cpu"
      "battery"
    ];
  };
  hyprland = common // {
    name = "hyprland";
    modules-left = [
      "idle_inhibitor"
      "hyprland/workspaces"
      "hyprland/submap"
    ];
    modules-center = [ "clock" ];
    modules-right = [
      "pulseaudio"
      "backlight"
      "network"
      "battery"
    ];
  };
in
{
  options = {
    psyclyx = {
      programs = {
        waybar = {
          enable = lib.mkEnableOption "Enable Waybar";
          cores = lib.mkOption {
            type = lib.types.ints.positive;
            description = "CPU core count";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      waybar = {
        enable = true;
      };
    };
    xdg.configFile = {
      "waybar/sway.json".text = builtins.toJSON sway;
      "waybar/hyprland.json".text = builtins.toJSON hyprland;
    };
  };
}
