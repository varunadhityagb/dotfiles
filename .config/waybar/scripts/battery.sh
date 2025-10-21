#!/bin/bash
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"
/home/varunadhityagb/Syncthing/widgets/.venv/bin/python /home/varunadhityagb/Syncthing/widgets/power_menu/config.py >>/home/varunadhityagb/Syncthing/widgets/power_menu/log
