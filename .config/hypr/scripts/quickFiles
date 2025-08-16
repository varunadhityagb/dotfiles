#!/bin/bash

FOLDER="/home/varunadhityagb/.hiddenFolder"
fileList=$(ls -1 $FOLDER)
echo $fileList
res=$(echo $fileList | tr ' ' '\n' | rofi -dmenu)
FILE="$FOLDER/$res"

if [ -z "$res" ]; then
    exit 0
elif [ $(head -c 4 "$FILE") == "%PDF" ]; then
    zathura "$FILE"
else
    xdg-open "$FILE"
fi
