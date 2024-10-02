{...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "wezterm";
      startup = [
        {command = "firefox";}
      ];
    };
  };
}
