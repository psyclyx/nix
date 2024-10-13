{pkgs, ...}: let
  mod = "Mod4";
in {
  imports = [
    ./theme.nix
    ./keybindings.nix
    ./waybar
  ];

  home.packages = with pkgs; [
    grim
    mako
    slurp
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = {
      floating = {
        criteria = [{app_id = "xdg-desktop-portal-gtk";}];
      };

      bars = [
        {command = "${pkgs.waybar}/bin/waybar";}
      ];

      defaultWorkspace = "workspace number 1";

      startup = [
        {command = "${pkgs.wezterm}/bin/wezterm";}
        {command = "${pkgs.firefox}/bin/firefox";}
        {command = "${pkgs.obsidian}/bin/obsidian";}
        {command = "${pkgs.signal-desktop}/bin/signal-desktop";}
      ];

      focus = {
        wrapping = "force";
        newWindow = "urgent";
      };

      assigns = {
        "1" = [
          # code
          {instance = "vscodium";}
        ];
        "2" = [
          # web
          {app_id = "firefox";}
        ];
        "3" = [
          # notes
          {instance = "obsidian";}
        ];
        "4" = [
          # chat
          {instance = "signal";}
        ];
      };

      workspaceAutoBackAndForth = true;
    };
  };
}
