#!/bin/bash

option_1=""
option_2="󰊻"
option_3=""
option_4="󰴢"
option_5=""
option_6=""
option_7=""
option_8="󰝆"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: 1; lines: 4;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-markup-rows \
		-theme ~/.config/rofi/quicklinks.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7\n$option_8" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		brave --app=https://web.whatsapp.com/
	elif [[ "$1" == '--opt2' ]]; then
		brave --app=https://teams.microsoft.com/
	elif [[ "$1" == '--opt3' ]]; then
		discord-development
	elif [[ "$1" == '--opt4' ]]; then
		brave --app=https://outlook.office.com/
	elif [[ "$1" == '--opt5' ]]; then
        brave --app=https://youtube.com/
    elif [[ "$1" == '--opt6' ]]; then
        brave --app=https://hotstar.com/
	elif [[ "$1" == '--opt7' ]]; then
        brave --app=https://primevideo.com/
    elif [[ "$1" == '--opt8' ]]; then
        brave --app=https://netflix.com/
	fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
    "$option_1")
		run_cmd --opt1
        ;;
    "$option_2")
		run_cmd --opt2
        ;;
    "$option_3")
		run_cmd --opt3
        ;;
    "$option_4")
		run_cmd --opt4
        ;;
    "$option_5")
        run_cmd --opt5
        ;;
    "$option_6")
        run_cmd --opt6
        ;;
    "$option_7")
        run_cmd --opt7
        ;;
    "$option_8")
        run_cmd --opt8
        ;;
esac
