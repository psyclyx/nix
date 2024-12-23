{
  config,
  lib,
  pkgs,
  ...
}: let
  sb = "${pkgs.sketchybar}/bin/sketchybar";
  aero = "/opt/homebrew/bin/aerospace";
  aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      ${sb} --set $NAME background.drawing=on
    else
      ${sb} --set $NAME background.drawing=off
    fi
  '';
  sketchybarrc = pkgs.writeShellScript "sketchybarrc" ''
    ${sb} -m --bar height=38 \
		   blur_radius=0 \
		   position=top \
		   padding_left=5 \
		   padding_right=5 \
		   margin=4 \
		   corner_radius=0 \
		   color=0xffFF3440 \
		   border_width=0 \
		   border_color=0xffff3440

  '';

  old = ''
    ${sb} --add item os left \
      --set os \
      icon= icon.color=0xFFFF3333 \
      icon.font.size=20 icon.y_offset=1 \
      icon.padding_left=7 icon.padding_right=0 \
      label.padding_left=0 label.padding_right=6 \
      click_script="${sb} -m --set $NAME popup.drawing=toggle" \
      popup.background.corner_radius=3 popup.background.border_color=#FF33FF33


    ${sb} --add event aerospace_workspace_change

    for sid in $(${aero} list-workspaces --all); do
      ${sb} --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=#0xff5555ff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        click_script="${aero} workspace $sid" \
        script="${aerospacePlugin} $sid"
    done

  '';
in {
    home.packages = [pkgs.sketchybar pkgs.jq pkgs.gh];
    launchd.agents.sketchybar = {
        enable = true;
        config = {
          ProgramArguments = [ sb "--reload" "-c" (toString sketchybarrc)];
          RunAtLoad = true;
          KeepAlive = {
            Crashed = true;
            SuccessfulExit = false;
          };
	};
    };
 }
