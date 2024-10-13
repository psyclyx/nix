{
  pkgs,
  config,
  ...
}: let
  mod = "Mod4";

  left = "h";
  down = "j";
  up = "k";
  right = "l";

  bemoji-pkg = pkgs.bemoji.overrideAttrs (
    prev: {
      buildInputs =
        (prev.buildInputs or [])
        ++ [
          pkgs.wl-clipboard
          pkgs.wtype
        ];
    }
  );

  light = "${pkgs.light}/bin/light";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  rofi = "${pkgs.rofi}/bin/rofi";
  bemoji = "${bemoji-pkg}/bin/bemoji";
  wezterm = "${pkgs.wezterm}/bin/wezterm";
in {
  wayland.windowManager.sway = {
    config = {
      keybindings = {
        "XF86MonBrightnessDown" = "exec ${light} -U 10";
        "XF86MonBrightnessUp" = "exec ${light} -A 10";

        "XF86AudioRaiseVolume" = "exec '${pactl} set-sink-volume @DEFAULT_SINK@ +5%'";
        "XF86AudioLowerVolume" = "exec '${pactl} set-sink-volume @DEFAULT_SINK@ -5%'";
        "XF86AudioMute" = "exec '${pactl} set-sink-mute @DEFAULT_SINK@ toggle'";

        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

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

        "${mod}+d" = "exec ${rofi}/bin/rofi -show drun";
        "${mod}+g" = "exec ${rofi}/bin/rofi -show filebrowser";
        "${mod}+m" = "exec ${bemoji}/bin/bemoji -t";
        "${mod}+Return" = "exec ${wezterm}/bin/wezterm";
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
          "${left}" = "resize shrink width 10 px or 10 ppt";
          "${down}" = "resize grow height 10 px or 10 ppt";
          "${up}" = "resize shrink height 10 px or 10 ppt";
          "${right}" = "resize grow width 10 px or 10 ppt";
          "Shift+${left}" = "resize shrink width 20 px or 20 ppt";
          "Shift+${down}" = "resize grow height 20 px or 20 ppt";
          "Shift+${up}" = "resize shrink height 20 px or 20 ppt";
          "Shift+${right}" = "resize grow width 20 px or 20 ppt";
        };
      };
    };
  };
}
