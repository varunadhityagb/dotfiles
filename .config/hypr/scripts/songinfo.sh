#!/bin/bash

players=$(playerctl --list-all)

# Check if 'cider' is in the list
if echo "$players" | grep -q "cider"; then
    song_info=$(playerctl metadata --format '{{title}}    {{artist}}')
else
    song_info=$(playerctl metadata --format '{{title}}     {{artist}}')
fi

echo "$song_info"
