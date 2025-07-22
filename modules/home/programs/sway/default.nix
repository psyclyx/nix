{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.psyclyx.programs.sway;
  waybarExe = lib.getExe config.programs.waybar.package;
  waybar-sway = pkgs.writeScript "waybar-sway" ''
    ${waybarExe} -c ${config.xdg.configHome}/waybar/sway.json
  '';
in
{
  imports = [
    ./keybindings.nix
  ];

  options = {
    psyclyx = {
      programs = {
        sway = {
          enable = lib.mkEnableOption "Sway config";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = null;
      extraConfig = ''
        output * scale 1
      '';
      config = {
        assigns = {
          "1" = [ { instance = "vscodium"; } ];
          "2" = [ { app_id = "firefox"; } ];
          "3" = [ { instance = "obsidian"; } ];
          "4" = [ { instance = "signal"; } ];
        };

        startup = [ { command = "waybar -c ~/.config/sway.json"; } ];
        bars = lib.mkForce [ { command = "${waybar-sway}"; } ];
        defaultWorkspace = "workspace number 1";
        floating = {
          criteria = [
            { app_id = "xdg-desktop-portal-gtk"; }
            {
              app_id = "firefox";
              title = "Library";
            }
          ];
        };
        focus = {
          wrapping = "force";
          newWindow = "urgent";
        };
        workspaceAutoBackAndForth = true;
      };
    };
  };
}
