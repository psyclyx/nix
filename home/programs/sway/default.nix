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
      menu = "${pkgs.wofi}/bin/wofi --show run";
      bars = [
        {command = "${pkgs.waybar}/bin/waybar";}
      ];
    };
    extraConfig = ''
      output * scale 1

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume
      bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
      bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
      bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
    '';
  };
}
