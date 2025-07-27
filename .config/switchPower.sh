#!/bin/bash

current=$(powerprofilesctl get);
case "$current" in
    "balanced")
        powerprofilesctl set power-saver
        ;;
    "power-saver")
        powerprofilesctl set performance
        ;;
    "performance")
        powerprofilesctl set balanced
        ;;
esac
