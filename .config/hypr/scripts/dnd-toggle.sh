#!/bin/bash

# Toggle DND
swaync-client --toggle-dnd

DND=$(swaync-client -D)

if $DND; then
  notify-send -a "System" "Do Not Disturb" "Turned on"
else
  notify-send -a "System" "Do Not Disturb" "Turned off"
fi

# Send signal to Waybar to update the module
pkill -RTMIN+10 waybar
