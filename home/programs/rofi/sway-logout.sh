#!/bin/sh

trap "" SIGTERM

swaymsg '[class=".*"] kill'

while true; do
    count=$(swaymsg -t get_tree | jq '[.. | objects | select(.type? == "con")] | length')
    if [ "$count" -eq 0 ]; then
        break
    fi
    sleep 1
done

swaymsg exit
