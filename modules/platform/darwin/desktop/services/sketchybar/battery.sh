#!/usr/bin/env bash
PERCENT=$(pmset -g batt | grep -Eo '[[:digit:]]+%' | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power' || echo "")
HIGHLIGHT=${CHARGING:+on}
HIGHLIGHT=${HIGHLIGHT:-off}


get_icon() {
  local percent=$1
  local charging=$2
  local charging_icons=("󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
  local battery_icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

  local icons
  if [ -n "$charging" ]; then
    icons=("${charging_icons[@]}")
  else
    icons=("${battery_icons[@]}")
  fi

  case $percent in
    100) echo "${icons[10]}" ;;
    9[0-9]) echo "${icons[9]}" ;;
    8[0-9]) echo "${icons[8]}" ;;
    7[0-9]) echo "${icons[7]}" ;;
    6[0-9]) echo "${icons[6]}" ;;
    5[0-9]) echo "${icons[5]}" ;;
    4[0-9]) echo "${icons[4]}" ;;
    3[0-9]) echo "${icons[3]}" ;;
    2[0-9]) echo "${icons[2]}" ;;
    1[0-9]) echo "${icons[1]}" ;;
    [0-9]) echo "${icons[0]}" ;;
  esac
}

ICON=$(get_icon "${PERCENT}" "${CHARGING}")


battery=(
  "icon=${ICON}"
  "label=${PERCENT}%"
  "icon.highlight=${HIGHLIGHT}"
)

sketchybar --set "${NAME}" "${battery[@]}"
