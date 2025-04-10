#!/bin/bash
mode=$(echo -e "screen1\nscreen2\nmult\nmirror" | rofi -dmenu)


case $mode in
    "screen1")
        hyprctl keyword monitor HDMI-A-1,disable
        hyprctl keyword monitor eDP-1,1600x900,auto,1
        ;;
    "screen2")
        hyprctl keyword monitor HDMI-A-1,prefered,0x0,1
        hyprctl keyword monitor eDP-1, disable
        ;;
    "mult")
        hyprctl keyword monitor HDMI-A-1, prefered, 0x0, 1
        hyprctl keyword monitor eDP-1,1600x900,auto,1
        ;;
    "mirror")
        hyprctl keyword monitor HDMI-A-1, prefered, 0x0, 1, mirror, eDP-1
        hyrpctl keyword monitor eDP-1,1600x900,auto,1
        ;;
esac
