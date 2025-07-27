#!/bin/bash
current=$(powerprofilesctl get);
case "$current" in
     "power-saver")
     echo '30'
     ;;
     "balanced")
     echo '60'
     ;;
     "performance")
     echo '90'
     ;;
     esac
