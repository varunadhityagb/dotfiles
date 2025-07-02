#!/bin/bash

if  [[ $1 -eq 0 ]]; then
    DEVICE=""
    BRIGHTNESS=$(brightnessctl get)
    MAX_BRIGHTNESS=$(brightnessctl max)
elif [[ $1 -eq 1 ]]; then
    DEVICE="Monitor"
    BRIGHTNESS=$(ddcutil getvcp 10 --bus 1 | awk -F'=' '{ print $2 }' | awk -F',' '{print $1}')
    MAX_BRIGHTNESS=$(ddcutil getvcp 10 --bus 1 | awk -F'=' '/Brightness/ { gsub(/,/, "", $3); print $3 }')
else
    echo "Usage: $0 [0|1]"
    exit 1
fi

BRIGHTNESS_PERCENT=$(( BRIGHTNESS * 100 / MAX_BRIGHTNESS ))

# Choose icon
if [ "$BRIGHTNESS_PERCENT" -lt 30 ]; then
    ICON="display-brightness-low"
elif [ "$BRIGHTNESS_PERCENT" -lt 70 ]; then
    ICON="display-brightness-medium"
else
    ICON="display-brightness-high"
fi

# Send notification
notify-send -h string:x-canonical-private-synchronous:system-info \
            -h int:value:"$BRIGHTNESS_PERCENT" \
            -i "$ICON" "$DEVICE Brightness: $BRIGHTNESS_PERCENT%"
