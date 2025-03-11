#!/usr/bin/env bash

SID=$1

if [ "${1}" = "${FOCUSED_WORKSPACE}" ]; then
  sketchybar --set "${NAME}" label.background.drawing=on
else
  sketchybar --set "${NAME}" label.background.drawing=off
fi


if [[ -n $(aerospace list-windows --workspace "${SID}") ]]; then
  sketchybar --set "${NAME}" label.highlight=on
else
  sketchybar --set "${NAME}" label.highlight=off
fi
