#!/bin/bash

FILE="/home/varunadhityagb/.config/hypr/conf/monitor.conf"

while [ 1 -eq 1 ]; 
do 
	mode=$(xrandr --listactivemonitors | grep ": 0")
	if [[ $mode == "Monitors: 0" ]]; then
		echo "source = ~/.config/hypr/conf/monitors/screen1.conf" > "$FILE"
	fi
	sleep 5
done
