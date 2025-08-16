#!/bin/bash

# Get current volume
VOL=$(pamixer --get-volume)
MUTE=$(pamixer --get-mute)

# Choose icon
if [ "$MUTE" = "true" ]; then
    ICON="audio-volume-muted"
elif [ "$VOL" -lt 30 ]; then
    ICON="audio-volume-low"
elif [ "$VOL" -lt 70 ]; then
    ICON="audio-volume-medium"
else
    ICON="audio-volume-high"
fi

# Send notification
notify-send -h string:x-canonical-private-synchronous:system-info \
            -h int:value:"$VOL" \
            -i "$ICON" "Volume: $VOL%"

