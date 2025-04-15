#!/usr/bin/env bash
set -x

bar=(
  height=24
  position=top
  padding_left=96
  padding_right=96
  y_offset="${Y_OFFSET}"
  color="#00000000"
  sticky=off
)

default=(
  icon.font="NotoMono Nerd Font Propo:Regular:16.0"
  icon.color="${THEME_BACKGROUND}"
  icon.highlight_color="${THEME_WM_FOCUSED_BACKGROUND}"

  label.font="NotoMono Nerd Font Propo: Regular:16.0"
  label.color="${THEME_WM_UNFOCUSED_BACKGROUND}"
  label.highlight_color="${THEME_WM_FOCUSED_BACKGROUND}"

  label.background.height=20
  background.height=24
  background.border_color="${THEME_BORDER}"
  background.border_width=2
  background.corner_radius=6
  blur_radius=2

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
  "label.highlight_color=${THEME_WM_FOCUSED_BACKGROUND}"
  "label.color=${THEME_WM_UNFOCUSED_INDICATOR}"
  "label.width=28"
  "label.align=center"
  "background.padding_left=2"
  "background.padding_right=2"
  "label.background.color=${THEME_WM_FOCUSED_BORDER}"
  "label.background.drawing=off"
)

sketchybar --add event aerospace_workspace_change

WORKSPACES=
for _i in 1 2 3; do
  WORKSPACES=$(aerospace list-workspaces --all)
  [[ -n "${WORKSPACES}" ]] && break
  sleep 1;
done;


FOCUSED=$(aerospace list-workspaces --focused)

for sid in ${WORKSPACES}; do
  sketchybar --add item space."${sid}" left \
             --set space."${sid}" \
             "${workspace[@]}" \
             script="aerospace_plugin ${sid}" \
             label="${sid:1}" \
             --subscribe space."${sid}" aerospace_workspace_change

  FOCUSED_WORKSPACE="${FOCUSED}" NAME="space.${sid}" aerospace_plugin "${sid}" &
done

sketchybar \
  --add bracket spaces '/space\..*/' \
  --set spaces \
  background.color="${THEME_WM_UNFOCUSED_BORDER}" \
  background.height=24\
  background.padding_left=2\
  background.padding_right=2\
  background.clip=1

sketchybar \
  --add item app_name left \
  --set app_name \
  background.color="${THEME_FOREGROUND}" \
  label.padding_left=8 \
  icon= \
  icon.color="${THEME_BACKGROUND_ALT}" \
  label.padding_right=8 \
  padding_left=64 \
  script="app_name_plugin" \
  --subscribe app_name front_app_switched


sketchybar \
  --add item battery right \
  --set battery \
  update_freq=4 \
  icon=BAT_INIT \
  icon.color="${THEME_TERMINAL_WHITE}" \
  icon.highlight_color="${THEME_TERMINAL_BRIGHT_GREEN}" \
  icon.font.size=15 \
  background.color="${THEME_FOREGROUND}" \
  script="battery_plugin"

sketchybar \
  --add item clock right \
  --set clock \
  update_freq=4 \
  icon= \
  icon.color="${THEME_TERMINAL_RED}" \
  background.color="${THEME_FOREGROUND}" \
  padding_right=64 \
  script="clock_plugin"

sketchybar \
  --add item mode right \
  --set mode \
  background.color="${THEME_FOREGROUND}" \
  label.color="${THEME_TERMINAL_BRIGHT_RED}" \
  icon.drawing=off \
  padding_right=64 \
  drawing=off

sketchybar --update
