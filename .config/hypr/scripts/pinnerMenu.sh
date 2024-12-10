#!/bin/bash

opt=$(echo -e "pin\nunpin\nlist" | rofi -dmenu)

pinner=~/.config/hypr/scripts/cliphistPinner.sh

if [[ $opt == "list" ]]; then
	$pinner list | rofi -dmenu | wl-copy
elif [[ $opt == "unpin" ]]; then 
	temp=$($pinner list | rofi -dmenu)
	$pinner unpin $temp  
elif [[ $opt == "pin" ]]; then
    temp=$(cliphist list | rofi -dmenu)

    if [[ -z "$temp" ]]; then
        echo "No item selected to decode."
        exit 1
    fi

    temp1=$(printf "%s\n" "$temp" | cliphist decode)  
    eval "$pinner pin $temp1"
else
	echo "Not Valid Option"
fi
