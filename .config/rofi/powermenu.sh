#!/usr/bin/env bash
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-mesg "Uptime: $uptime" \
		-theme ~/.config/rofi/powermenu.rasi
}


# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
    shutdown now
        ;;
    $reboot)
    reboot
        ;;
    $lock)
    /usr/bin/hyprlock
        ;;
    $suspend)
    systemctl suspend
        ;;
    $logout)
    hyprctl dispatch exit
        ;;
esac
