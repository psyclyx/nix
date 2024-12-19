{
  config,
  lib,
  pkgs,
  ...
}: let
  sb = "${pkgs.sketchybar}/bin/sketchybar";
  aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      ${sb} --set $NAME background.drawing=on
    else
      ${sb} --set $NAME background.drawing=off
    fi
  '';
  sketchybarrc = pkgs.writeShellScript "sketchybarrc" ''
    ${sb} --add item os left \
      --set os \
      icon= icon.color=0xff212122 \
      icon.font.size=20 icon.y_offset=1 \
      icon.padding_left=7 icon.padding_right=0 \
      label.padding_left=0 label.padding_right=6 \
      click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
      popup.background.corner_radius=3 popup.background.border_color=#FF#f9f9fa

    ${sb} --bar \
      margin=0 y_offset=0 height=38 \
      corner_radius=0 blur_radius=10 \
      border_width=0 \
      padding_left=17 padding_right=17 \
      color=#FF45586a

    ${sb} --add event aerospace_workspace_change

    for sid in $(aerospace list-workspaces --all); do
      ${sb} --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=#0xff212122 \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="${aerospacePlugin}aerospace.sh $sid"
    done
  '';
in {
  home.file.".config/sketchybar/sketchybarrc".source = sketchybarrc;
}
