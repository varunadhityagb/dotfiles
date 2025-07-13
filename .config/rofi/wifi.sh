#!/bin/bash

notify-send -t 3000 "Getting list of available networks ... "

# Get Wi-Fi connections
wifi_list=$(nmcli --fields "SIGNAL,SECURITY,SSID,IN-USE" device wifi list |
                sed 1d |
                sed '/--/d' |
                sed 's/WPA[0-9]*//' |
                sed 's/WPA[0-9]*//' |
                sed 's/802.1X//' |
                sed 's/  */ /g' |
                sed "s/*//g" |
                sed 's/^\([0-9][0-9]*\)/\1% /' |
                sed 's/$/ /' |
                awk '{if ($2 == "AMRITA-BLR-Connect") {if ($1 > max) {max=$1; line=$0}} else print $0} END {print line}' |
                sort -r
)
#

# Get Wi-Fi power status
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="󱚼  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="󱚽  Enable Wi-Fi"
fi

# Build menu string
menu_string=$(echo -e "$toggle\n$wifi_list")

# Launch rofi to select network
chosen_network=$(echo -e "$menu_string" | rofi -dmenu -p "Wi-Fi SSID:" -theme ~/.config/rofi/wifi.rasi)

# Get name of connection
chosen_id=$(echo "${chosen_network:5}" | sed 's/ //' | sed 's///' | xargs)

# Get saved connections
saved_connections=$(nmcli -g NAME connection)

# Find matching saved connection
match_id=$(echo "$saved_connections" | grep -w "$chosen_id")

# Handle selection
if [ -z "$chosen_network" ]; then
    exit

elif [ "$chosen_network" = "󱚽  Enable Wi-Fi" ]; then
    nmcli radio wifi on
    notify-send -t 5000 "WiFi status" "powered on"

elif [ "$chosen_network" = "󱚼  Disable Wi-Fi" ]; then
    nmcli radio wifi off
    notify-send -t 5000  "WiFi status" "is off now"

elif echo "$chosen_network" | grep -q ""; then
    nmcli connection down "$chosen_id" | grep "successfully" && notify-send -t 5000 "$chosen_id" "Has been disconnected"
    nmcli connection down "$match_id" | grep "successfully" && notify-send -t 5000 "$chosen_id" "Has been disconnected"

else
    success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."

    if [[ "$match_id" != "" ]]; then
        nmcli connection up id "$match_id" | grep "successfully" && notify-send -t 7000 "Connection Established" "$success_message"
    else
        if echo "$chosen_network" | grep -q ""; then
            wifi_password=$(rofi -dmenu -password -p "Password for $chosen_id :" -theme ~/.config/rofi/password.rasi)
        fi

        if [[ "$wifi_password" != "" ]]; then
            nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send -t 7000 "Connection Established" "$success_message"
        fi

    fi
fi
