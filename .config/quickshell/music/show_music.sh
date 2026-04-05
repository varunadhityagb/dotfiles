#!/bin/bash
pkill lyric_daemon 2>/dev/null
~/dotfiles/.config/quickshell/music/lyric_daemon/build/lyric_daemon &
qs -c music
pkill lyric_daemon 2>/dev/null
