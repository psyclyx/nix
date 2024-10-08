{pkgs, ...}: let
  mod = "Mod4";
  c = import ../../colors.nix;
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
  ];
  programs.swaylock.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      floating.modifier = mod;
      modifier = mod;
      menu = "${pkgs.wofi}/bin/wofi --show run";
      bars = [
        {command = "${pkgs.waybar}/bin/waybar";}
      ];
      gaps = {
        inner = 8;
        outer = 4;
      };

      colors = {
        background = c.bg;
        focused = {
          border = c.base-dark;
          background = c.base-dark;
          text = c.fg;
          indicator = c.accent;
          childBorder = c.base-dark;
        };
        focusedInactive = {
          border = c.base-dark;
          background = c.base;
          text = c.fg-light;
          indicator = c.accent;
          childBorder = c.base-dark;
        };
        unfocused = {
          border = c.base-light;
          background = c.base-light;
          text = c.fg-light;
          indicator = c.accent;
          childBorder = c.base-light;
        };
        urgent = {
          border = c.red2;
          background = c.red2;
          text = c.coffee4;
          indicator = c.coffee4;
          childBorder = c.red3;
        };
        placeholder = {
          border = c.red2;
          background = c.red2;
          text = c.red4;
          indicator = c.red4;
          childBorder = c.red3;
        };
      };

      keybindings = {
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";

        "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+a" = "focus parent";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+Shift+q" = "kill";

        "${mod}+d" = "exec ${pkgs.wofi}/bin/wofi --show run";
        "${mod}+Return" = "exec ${pkgs.wezterm}/bin/wezterm";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        "${mod}+r" = "resize";

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
      };
    };

    extraConfig = ''
      output * scale 1
      output * bg ${c.bg-dark} solid_color
      workspace 1
    '';
  };
}
