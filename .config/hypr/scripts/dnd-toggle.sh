#!/bin/bash

# Toggle DND
swaync-client --toggle-dnd

# Send signal to Waybar to update the module
pkill -RTMIN+10 waybar
