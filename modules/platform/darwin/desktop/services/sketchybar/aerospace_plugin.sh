#!/usr/bin/env bash

SID=$1

if [ "${1}" = "${FOCUSED_WORKSPACE}" ]; then
  workspace=(
    "label.background.drawing=on"
    "label.highlight=on"
  )
else
  workspace=(
    "label.background.drawing=off"
    "label.highlight=off"
  )
fi

sketchybar \
  --set "${NAME}" "${workspace[@]}"


if [[ -n $(aerospace list-windows --workspace "${SID}") ]]; then
  sketchybar --set "${NAME}" label.highlight=on;
fi
