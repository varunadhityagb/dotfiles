#!/bin/bash

# Device configuration
# Format: device_name, preferred_resolution, auto settings, transform state, etc.
MONITORS=(
    "HDMI-A-1,preferred,0x0,1"
    "eDP-1,1600x900,auto,1"
)

# Ensure that an index is passed as a parameter
if [ $# -eq 0 ]; then
    echo "Usage: $0 <monitor_index>"
    exit 1
fi

# Get the monitor index from the parameter
monitor_index=$1

# Validate the monitor index
if [[ $monitor_index -lt 0 || $monitor_index -ge ${#MONITORS[@]} ]]; then
    echo "Invalid monitor index. Please provide a valid index."
    exit 1
fi

# Get the configuration for the selected monitor
monitor_config=${MONITORS[$monitor_index]}
IFS=',' read -r device_name preferred_resolution auto_settings scale <<< "$monitor_config"


# File to store the current state of the device
STATE_FILE="$HOME/.hyprctl_x_state_$device_name"

# Check if the state file exists, if not, initialize it to 0
if [ ! -f "$STATE_FILE" ]; then
    echo 0 > "$STATE_FILE"
fi

# Read the current state
current_state=$(cat "$STATE_FILE")

# Determine the next state (0, 1, 2, or 3)
case $current_state in
    0) next_state=1 ;;
    1) next_state=2 ;;
    2) next_state=3 ;;
    3) next_state=0 ;;
    *) next_state=0 ;;  # Default to 0 in case of an invalid state
esac

# Update the state file with the new value
echo $next_state > "$STATE_FILE"

# Build the hyprctl command based on the monitor configuration
hyprctl_command="hyprctl keyword monitor $device_name,$preferred_resolution,$auto_settings,$scale,transform,$next_state"

# Run the hyprctl command with the new value of X for the selected device
$hyprctl_command

echo "Toggled $device_name to X=$next_state"
