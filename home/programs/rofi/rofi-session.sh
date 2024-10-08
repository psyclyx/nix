#!/usr/bin/env sh
#
# A rofi powered menu to execute power related action.
# Uses: amixer mpc poweroff reboot rofi rofi-prompt

lock='Lock'
log_out='Log out'

chosen=$(printf '%s;%s;\n' "$lock" "$log_out" \
    | rofi \
           -dmenu \
           -sep ';' )

case "$chosen" in
    "$lock")
        swaylock
        ;;

    "$log_out")
        ~/bin/rofi-prompt --query "Log out?" && swaymsg '[class=".*"]' kill && swaymsg exit
        ;;

    *) exit 1 ;;
esac
