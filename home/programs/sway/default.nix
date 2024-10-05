{pkgs, ...}: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];
  programs.swaylock.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "wezterm";
      menu = "${pkgs.rofi-wayland}/bin/rofi -show drun -modi drun";
    };
    extraConfig = ''
      output * scale 1
    '';
  };
}
