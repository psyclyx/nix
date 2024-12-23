#!/usr/bin/env bash

sketchybar --bar position=top height=38 blur_radius=30 color=0x40000000


default=(
  padding_left=5
  padding_right=5
  icon.font="NotoSans Nerd Font:Bold:17.0"
  label.font="NotoSans Font:Bold:14.0"
  icon.color=0xffffffff
  label.color=0xffffffff
  icon.padding_left=4
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=4
)

sketchybar --default "${default[@]}"

sketchybar --update
