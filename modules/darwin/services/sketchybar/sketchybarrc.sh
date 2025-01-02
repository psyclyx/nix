#!/usr/bin/env bash
set -x

bar=(
  height=28
  position=top
  padding_left=24
  padding_right=24
  color="${THEME_BACKGROUND}"
  sticky=off
)

default=(
  icon.font="NotoMono Nerd Font Propo:Regular:16.0"
  icon.color="${THEME_FOREGROUND}"
  icon.highlight_color="${THEME_WM_FOCUSED_TEXT}"

  label.font="NotoMono Nerd Font Propo: Regular:16.0"
  label.color="${THEME_WM_UNFOCUSED_TEXT}"
  label.highlight_color="${THEME_WM_FOCUSED_TEXT}"

  label.padding_left=4
  label.padding_right=8
  icon.padding_left=8
  icon.padding_right=4
)

sketchybar \
  --bar "${bar[@]}" \
  --default "${default[@]}"


workspace=(
  "icon.drawing=off"

  "label.font=NotoMono Nerd Font Propo: Regular:16.0"
  "icon.font=NotoMono Nerd Font Propo: Regular:16.0"
  "label.highlight_color=${THEME_WM_FOCUSED_TEXT}"
  "label.color=${THEME_WM_UNFOCUSED_TEXT}"
  "label.width=36"
  "label.align=center"
  "label.background.height=36"

  "background.color=${THEME_WM_UNFOCUSED_BACKGROUND}"
)

sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space."${sid}" left \
	     --set space."${sid}" \
	       "${workspace[@]}" \
	       script="aerospace_plugin ${sid}" \
	       label="${sid}" \
	     --subscribe space."${sid}" aerospace_workspace_change
done

sketchybar \
  --add item battery right \
  --set battery \
  update_freq=4 \
  icon=BAT_INIT \
  icon.highlight_color="${THEME_TERMINAL_BRIGHT_GREEN}" \
  background.color="${THEME_BACKGROUND_ALT}" \
  script="battery_plugin"

sketchybar \
  --add item clock right \
  --set clock \
  update_freq=10 \
  icon= \
  icon.color="${THEME_TERMINAL_RED}" \
  background.color="${THEME_BACKGROUND_ALT}" \
  padding_right=16 \
  script="clock_plugin"


sketchybar --update
