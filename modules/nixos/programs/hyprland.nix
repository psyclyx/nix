{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.psyclyx.programs.hyprland;
in
{
  imports = [ inputs.hyprland.nixosModules.default ];
  options.psyclyx.programs.hyprland.enable = lib.mkEnableOption "Hyprland session";
  config = lib.mkMerge [
    {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    }
    (lib.mkIf cfg.enable {
      security.pam.services.hyprlock = { };
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
      programs.hyprlock.enable = true;
      services.hypridle.enable = true;
      xdg.portal = {
        enable = true;
      };
    })
  ];
}
