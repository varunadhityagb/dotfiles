#!/bin/bash

FILE="/home/varunadhityagb/.config/hypr/conf/monitor.conf"


# Read the current content of the file
CURRENT_CONTENT=$(<"$FILE")


mode=$(echo -e "screen1\nscreen2\nmult\nmirror" | rofi -theme $HOME/.config/rofi/launchers/type-1/style-4.rasi -dmenu)


echo "source = ~/.config/hypr/conf/monitors/$mode.conf" > "$FILE"
