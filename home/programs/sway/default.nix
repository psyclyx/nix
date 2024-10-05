{pkgs, ...}: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];
  wayland.windowManager.sway = {
    services.gnome.gnome-keyring.enable = true;
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
