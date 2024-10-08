{pkgs, ...}: let
  mod = "Mod4";
  c = import ../../colors.nix;
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
    wtype
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

      startup = [
        {command = "${pkgs.wezterm}/bin/wezterm";}
        {command = "${pkgs.firefox}/bin/firefox";}
        {command = "${pkgs.obsidian}/bin/obsidian";}
      ];

      assigns = {
        "1" = [
          # term
          {app_id = "org.wezfurlong.wezterm";}
        ];
        "2" = [
          # web
          {app_id = "firefox";}
        ];
        "3" = [
          # notes
          {instance = "obsidian";}
        ];
      };
      gaps = {
        inner = 8;
        outer = 4;
      };

      window = {
        border = 2;
      };

      fonts = {
        names = ["NotoMono Nerd Font"];
        size = 10.0;
      };

      colors = {
        background = c.bg;
        focused = {
          border = c.base;
          background = c.base;
          text = c.fg-light;
          indicator = c.accent;
          childBorder = c.base;
        };
        focusedInactive = {
          border = c.base-dark;
          background = c.base;
          text = c.fg;
          indicator = c.accent;
          childBorder = c.base-dark;
        };
        unfocused = {
          border = c.base-dark;
          background = c.base-dark;
          text = c.fg;
          indicator = c.accent;
          childBorder = c.base-dark;
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
        "${mod}+c" = "focus child";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+Shift+q" = "kill";

        "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+g" = "exec ${pkgs.rofi}/bin/rofi -show filebrowser";
        "${mod}+m" = "exec ${pkgs.bemoji}/bin/bemoji -t";
        "${mod}+Return" = "exec ${pkgs.wezterm}/bin/wezterm";
        "${mod}+Shift+e" = "exec ~/bin/rofi-session";
        "${mod}+Shift+c" = "reload";

        "${mod}+r" = "mode resize";

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

        "${mod}+period" = "workspace next";
        "${mod}+comma" = "workspace prev";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 0";

        "${mod}+Shift+period" = "move container to workspace next; workspace-next";
        "${mod}+Shift+comma" = "move container to workspace prev; workspace-prev";

        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";
      };
      modes = {
        resize = {
          Escape = "mode default";
          Return = "mode default";
          "h" = "resize shrink width 10 px or 10 ppt";
          "j" = "resize grow height 10 px or 10 ppt";
          "k" = "resize shrink height 10 px or 10 ppt";
          "l" = "resize grow width 10 px or 10 ppt";
          "Shift+h" = "resize shrink width 50 px or 50 ppt";
          "Shift+j" = "resize grow height 50 px or 50 ppt";
          "Shift+k" = "resize shrink height 50 px or 50 ppt";
          "Shift+l" = "resize grow width 50 px or 50 ppt";
        };
      };
    };

    extraConfig = ''
      output * scale 1
      output * bg ${c.bg} solid_color
      workspace 1
      smart_gaps inverse_outer
    '';
  };
}
