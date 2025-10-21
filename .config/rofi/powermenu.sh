#!/usr/bin/env bash
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=' Shutdown'
reboot=' Reboot'
sleep='󰒲 Sleep'
logout=' Logout'

screen_time="`screen_timer status`"
# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-mesg "$screen_time" \
		-theme ~/.config/rofi/powermenu.rasi
}


# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$sleep\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
            shutdown now
        ;;
    $reboot)
    reboot
        ;;
    $sleep)
    systemctl suspend
        ;;
    $logout)
    hyprctl dispatch exit
        ;;
esac
