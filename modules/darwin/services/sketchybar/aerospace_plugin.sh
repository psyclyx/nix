#!/usr/bin/env bash

if [ "${1}" = "${FOCUSED_WORKSPACE}" ]; then
  workspace=(
    "background.color=${THEME_WM_FOCUSED_BACKGROUND}"
    "label.highlight=on"
  )
else
  workspace=(
    "background.color=${THEME_WM_UNFOCUSED_BACKGROUND}"
    "label.highlight=off"
  )
fi


sketchybar --set "${NAME}" "${workspace[@]}"
