{pkgs, lib, ...}:

let
  colors = import ../../../home/themes/angel.nix { inherit lib; };
  theme = colors.colorUtils.mkTheme "sketchybar";
  aerospacePlugin = pkgs.writeShellScript "aerospace_plugin" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then

    sketchybar --set $NAME \
        background.color=${theme.wm.focused.background} \
        label.highlight=on
    else
    sketchybar --set $NAME \
        background.color=${theme.wm.unfocused.background} \
        label.highlight=off
    fi

  '';
  clockPlugin = pkgs.writeShellScript "clock_plugin" ''
    sketchybar --set $NAME label="$(date '+%H:%M')"
  '';
  newRc = ''
    bar=(
        height=28
        position=top
        padding_left=24
        padding_right=24
        color=${theme.background}
        sticky=off
        )

    default=(
        icon.font="NotoSans Nerd Font Propo:Bold:16.0"
        icon.color=${theme.foreground}
        icon.highlight_color=${theme.wm.focused.text}
	label.font="NotoSans Font Propo:Regular:16.0"
        label.color=${theme.wm.unfocused.text}
        label.highlight_color=${theme.wm.focused.text}
        label.padding_left=6
        label.padding_right=6
    )

    sketchybar \
        --bar "''\${bar[@]}" \
        --default "''\${default[@]}"

    sketchybar --add event aerospace_workspace_change
    for sid in $(aerospace list-workspaces --all); do
        sketchybar --add item space.$sid left \
	    --set space.$sid \
                script="${aerospacePlugin} $sid" \
		padding_left=6\
		padding_right=6 \
                icon.width=0\
		label.font="NotoMono Nerd Font: Regular:16.0"\
		background.highlight_color=${theme.wm.focused.background} \
		background.color=${theme.wm.unfocused.background} \
		label.color=${theme.wm.unfocused.text}\
		label.highlight_color=${theme.wm.focused.text}\
                label.width=36\
		label.align=center\
                label.background.width=36\
		height=28\
                icon.drawing=off\
		label="$sid" \
            --subscribe space.$sid aerospace_workspace_change
    done

sketchybar \
    --add item clock right \
    --set clock \
        update_freq=10 \
        icon= \
        script=${clockPlugin}

sketchybar --update
  '';
  temp = ''



sketchybar \
    --add item date right \
    --set date update_freq=10 \
        icon=$ICON_CALENDAR  \
	script="~/.config/sketchybar/plugins/date.sh"

sketchybar --add item battery right \
           --set battery update_freq=30 \
                 script="~/.config/sketchybar/plugins/batt.sh"

sketchybar --add bracket r time date battery \
           --set r background.color=0xff686868 \
                   background.corner_radius=3 \
		   background.border_width=1 \
                   background.border_color="$bdcolor" \
                   background.height=24
    '';
  rc = ''
    sketchybar --bar \
	height=36 \
	margin=8 \
	corner_radius=14 \
        color=${theme.background} \
	border_color=0x00000000 \
	border_width=2\
	topmost=2\
        y_offset=3

    sketchybar --default \
	label.font="NotoSans Font Propo:Regular:14.0" \
	label.color=${theme.foreground} \
        label.highlight_color=${theme.wm.focused.indicator} \
        label.drawing=on \
	icon.font="NotoSans Nerd Font Propo:Bold:14.0" \
	icon.color=${theme.foreground}



    sketchybar --add event aerospace_workspace_change
    for sid in $(aerospace list-workspaces --all); do
	sketchybar \
	    --add item space.$sid left \
	    --subscribe space.$sid aerospace_workspace_change \
	    --set space.$sid \
                padding_left=5 \
		padding_right=5 \
                label.padding_left=5 \
		label.padding_right=5 \
		label.align=center \
		label="$sid" \
		click_script="aerospace workspace $sid" \
		script="${aerospacePlugin} $sid"
    done

    sketchybar \
    --add item clock right \
    --set clock \
        update_freq=10 \
        icon= \
        script=${clockPlugin}

    sketchybar --update
  '';

in
  {
    services.sketchybar = {
      enable = true;
      config = newRc;
      extraPackages = [pkgs.aerospace];
    };
  }
