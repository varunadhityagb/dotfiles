#!/bin/bash
album_art=$(playerctl metadata mpris:artUrl)
if [[ -z $album_art ]]; then
  rm /tmp/cover.jpeg
  exit
fi

song_st=$(playerctl status)
if [[ "$song_st" == "Paused" ]]; then
  rm /tmp/cover.jpeg
  exit
fi

curl -s "${album_art}" --output "/tmp/cover.jpeg"
echo "/tmp/cover.jpeg"
