#!/usr/bin/env bash

exec &>> /tmp/sk-bat.log
set -x

echo "bat start" > /tmp/sk-bat.log

{ which grep; which pmset; which cut; } >> /tmp/sk-bat.log

pmset -g batt
PERCENT=$(pmset -g batt | grep -Eo '[[:digit:]]+%' | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')
HIGHLIGHT=${CHARGING:+on}
HIGHLIGHT=${HIGHLIGHT:-off}

printenv >> /tmp/sk-bat.log

get_icon() {
    local percent=$1
    local charging=$2
    local base_icon=${charging:+"󰂅󰂋󰂊󰢞󰂉󰢝󰂈󰂇󰂆󰢜󰢟":"󰁹󰂂󰂁󰂀󰁿󰁾󰁽󰁼󰁻󰁺󰂎"}

    case $percent in
        100) echo "${base_icon:0:4}" ;;
        9[0-9]) echo "${base_icon:4:4}" ;;
        8[0-9]) echo "${base_icon:8:4}" ;;
        7[0-9]) echo "${base_icon:12:4}" ;;
        6[0-9]) echo "${base_icon:16:4}" ;;
        5[0-9]) echo "${base_icon:20:4}" ;;
        4[0-9]) echo "${base_icon:24:4}" ;;
        3[0-9]) echo "${base_icon:28:4}" ;;
        2[0-9]) echo "${base_icon:32:4}" ;;
        1[0-9]) echo "${base_icon:36:4}" ;;
        *) echo "${base_icon:40:4}"
    esac
}

echo "getting icon" >> /tmp/sk-bat.log
ICON=$(get_icon "${PERCENT}" "${CHARGING}")

battery=(
  "icon=${ICON}"
  "label=${PERCENT}%"
  "icon.highlight=${HIGHLIGHT}"
)

echo "setting" >> /tmp/sk-bat.log
printenv >> /tmp/sb-bat.log

sketchybar --set "${NAME}" "${battery[@]}"
