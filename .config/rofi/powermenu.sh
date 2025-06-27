#!/usr/bin/env bash
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
logout=' Logout'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-mesg "Uptime: $uptime" \
		-theme ~/.config/rofi/powermenu.rasi
}


# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}
stat=$(hyprctl clients)




# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        if [[ "$stat" ==  "unknown request" ]]; then
            shutdown now
        else
            open_windows=$(echo "$stat"| grep 'class:' | awk '{print $2}' | sort | uniq)
            notify-send "The following Windows are open" "$open_windows"
        fi
        ;;
    $reboot)
    reboot
        ;;
    $lock)
    /usr/bin/hyprlock
        ;;
    $logout)
    hyprctl dispatch exit
        ;;
esac
