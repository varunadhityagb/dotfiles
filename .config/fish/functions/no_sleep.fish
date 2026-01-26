function no_sleep
    notify-send "🛑 No Sleep Mode" "Lid close will NOT suspend the system."
    systemd-inhibit --what=handle-lid-switch --who="Hyprland" --why="Temporarily disabling lid sleep" bash &
end
