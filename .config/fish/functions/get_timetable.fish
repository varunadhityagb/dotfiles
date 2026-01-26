function get_timetable
    if test (count $argv) -eq 0
        ~/random_scripts/timetable.sh aie-e 6
    else if string match -qr '^[+-]' $argv[1]
        ~/random_scripts/timetable.sh aie-e 6 $argv[1]
    else
        ~/random_scripts/timetable.sh $argv
    end
end
