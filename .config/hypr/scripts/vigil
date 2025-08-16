#!/bin/bash

# Check if Vigiland is already running
if pgrep vigiland > /dev/null
then
    # If Vigiland is running, stop it
    killall vigiland
    notify-send "Vigiland has been stopped."
else
    # If Vigiland is not running, start it
    vigiland &
    notify-send "Vigiland has been started."
fi
