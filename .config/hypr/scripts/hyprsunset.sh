#!/bin/bash

if pgrep -x "hyprsunset" > /dev/null
then
    echo "hyprsunset is already running"
    killall hyprsunset;
else
    echo "hyprsunset is not running"
    value=$(rofi -theme $HOME/.config/rofi/launchers/type-1/style-10.rasi -dmenu -i -p "Enter the value")
    if [ -z "$value" ]
    then
         hyprsunset -t 4500;
        exit
    else
         hyprsunset -t $value;
    fi
fi
