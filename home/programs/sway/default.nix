{pkgs, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "wezterm";
      menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -modi drun";
    };
    extraConfig = ''
      output * scale 2
    '';
  };
}
