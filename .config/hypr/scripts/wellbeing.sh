#!/bin/bash

# Digital Wellbeing Tracker
# Tracks screen time, battery cycles, charge duration, and usage patterns

DATADIR="$HOME/.wellbeing"
LOGFILE="$DATADIR/screentime.log"
BATTERY_LOG="$DATADIR/battery.log"
CHARGE_LOG="$DATADIR/charges.log"
SESSION_LOG="$DATADIR/sessions.log"
STATS_FILE="$DATADIR/stats.json"

# Initialize data directory
mkdir -p "$DATADIR"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get battery information
get_battery_info() {
    local bat_path="/sys/class/power_supply/BAT0"
    local bat_path_alt="/sys/class/power_supply/BAT1"

    if [ -d "$bat_path" ]; then
        BAT="$bat_path"
    elif [ -d "$bat_path_alt" ]; then
        BAT="$bat_path_alt"
    else
        echo "no_battery"
        return 1
    fi

    if [ -f "$BAT/capacity" ]; then
        cat "$BAT/capacity"
    else
        echo "unknown"
    fi
}

get_battery_status() {
    local bat_path="/sys/class/power_supply/BAT0"
    local bat_path_alt="/sys/class/power_supply/BAT1"

    if [ -d "$bat_path" ]; then
        BAT="$bat_path"
    elif [ -d "$bat_path_alt" ]; then
        BAT="$bat_path_alt"
    else
        echo "Unknown"
        return 1
    fi

    if [ -f "$BAT/status" ]; then
        cat "$BAT/status"
    else
        echo "Unknown"
    fi
}

get_charge_cycles() {
    local bat_path="/sys/class/power_supply/BAT0"
    local bat_path_alt="/sys/class/power_supply/BAT1"

    if [ -d "$bat_path" ]; then
        BAT="$bat_path"
    elif [ -d "$bat_path_alt" ]; then
        BAT="$bat_path_alt"
    else
        echo "0"
        return 1
    fi

    if [ -f "$BAT/cycle_count" ]; then
        cat "$BAT/cycle_count"
    else
        # Estimate from log if not available
        if [ -f "$CHARGE_LOG" ]; then
            grep "^charge_complete" "$CHARGE_LOG" | wc -l
        else
            echo "0"
        fi
    fi
}

# Convert seconds to human readable format
human_readable_time() {
    local seconds=$1
    local days=$((seconds / 86400))
    local hours=$(((seconds % 86400) / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))

    local output=""
    [ $days -gt 0 ] && output="${output}${days}d "
    [ $hours -gt 0 ] && output="${output}${hours}h "
    [ $minutes -gt 0 ] && output="${output}${minutes}m "
    [ $secs -gt 0 ] && output="${output}${secs}s"

    echo "${output:-0s}"
}

# Log screen on/off
log_screen() {
    local state=$1
    local timestamp=$(date +%s)
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')

    echo "$timestamp $state $datetime" >>"$LOGFILE"

    # If turning screen on, start a new session
    if [ "$state" == "on" ]; then
        local battery=$(get_battery_info)
        local bat_status=$(get_battery_status)
        echo "$timestamp session_start battery:$battery status:$bat_status" >>"$SESSION_LOG"
    fi
}

# Log battery events
log_battery() {
    local event=$1
    local timestamp=$(date +%s)
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')
    local battery=$(get_battery_info)

    echo "$timestamp $event battery:$battery $datetime" >>"$BATTERY_LOG"
}

# Log charge cycle
log_charge() {
    local event=$1
    local timestamp=$(date +%s)
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')
    local battery=$(get_battery_info)

    echo "$timestamp $event battery:$battery $datetime" >>"$CHARGE_LOG"
}

# Calculate today's screen time
get_today_screentime() {
    local today=$(date +%Y-%m-%d)
    local total=0
    local last_on=0

    if [ ! -f "$LOGFILE" ]; then
        echo 0
        return
    fi

    while read -r time state datetime rest; do
        local log_date=$(echo "$datetime" | cut -d' ' -f1)

        if [ "$log_date" == "$today" ]; then
            if [ "$state" == "on" ]; then
                last_on=$time
            elif [ "$state" == "off" ]; then
                if [ $last_on -ne 0 ]; then
                    local diff=$((time - last_on))
                    total=$((total + diff))
                    last_on=0
                fi
            fi
        fi
    done <"$LOGFILE"

    # If screen is currently on, add time until now
    if [ $last_on -ne 0 ]; then
        local now=$(date +%s)
        local diff=$((now - last_on))
        total=$((total + diff))
    fi

    echo $total
}

# Calculate total screen time
get_total_screentime() {
    local total=0
    local last_on=0

    if [ ! -f "$LOGFILE" ]; then
        echo 0
        return
    fi

    while read -r time state rest; do
        if [ "$state" == "on" ]; then
            last_on=$time
        elif [ "$state" == "off" ]; then
            if [ $last_on -ne 0 ]; then
                local diff=$((time - last_on))
                total=$((total + diff))
                last_on=0
            fi
        fi
    done <"$LOGFILE"

    # If screen is currently on, add time until now
    if [ $last_on -ne 0 ]; then
        local now=$(date +%s)
        local diff=$((now - last_on))
        total=$((total + diff))
    fi

    echo $total
}

# Get current charge cycle info
get_current_charge_info() {
    if [ ! -f "$CHARGE_LOG" ]; then
        echo "No charge data available"
        return
    fi

    # Find last charge_start that doesn't have a corresponding charge_complete
    local last_charge_start=0
    local last_charge_battery=0
    local charge_complete=0

    while read -r time event battery_info rest; do
        if [ "$event" == "charge_start" ]; then
            last_charge_start=$time
            last_charge_battery=$(echo "$battery_info" | cut -d: -f2)
            charge_complete=0
        elif [ "$event" == "charge_complete" ]; then
            if [ $last_charge_start -ne 0 ]; then
                charge_complete=1
            fi
        fi
    done <"$CHARGE_LOG"

    if [ $last_charge_start -ne 0 ] && [ $charge_complete -eq 0 ]; then
        local now=$(date +%s)
        local duration=$((now - last_charge_start))
        local current_battery=$(get_battery_info)
        echo "charging:$duration:$last_charge_battery:$current_battery"
    else
        echo "not_charging"
    fi
}

# Get battery life in current discharge cycle
get_current_discharge_info() {
    if [ ! -f "$BATTERY_LOG" ]; then
        echo "No battery data available"
        return
    fi

    # Find last unplug event
    local last_unplug=0
    local last_unplug_battery=0

    while read -r time event battery_info rest; do
        if [ "$event" == "unplug" ]; then
            last_unplug=$time
            last_unplug_battery=$(echo "$battery_info" | cut -d: -f2)
        elif [ "$event" == "plug" ]; then
            last_unplug=0 # Reset if plugged in
        fi
    done <"$BATTERY_LOG"

    if [ $last_unplug -ne 0 ]; then
        local now=$(date +%s)
        local duration=$((now - last_unplug))
        local current_battery=$(get_battery_info)
        local battery_used=$((last_unplug_battery - current_battery))
        echo "unplugged:$duration:$last_unplug_battery:$current_battery:$battery_used"
    else
        echo "plugged_in"
    fi
}

# Display statistics
show_stats() {
    echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║      Digital Wellbeing Dashboard          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
    echo ""

    # Screen Time
    echo -e "${YELLOW}📱 Screen Time${NC}"
    local today_time=$(get_today_screentime)
    local total_time=$(get_total_screentime)
    echo -e "  Today: ${GREEN}$(human_readable_time $today_time)${NC}"
    echo -e "  Total: $(human_readable_time $total_time)"
    echo ""

    # Battery Info
    echo -e "${YELLOW}🔋 Battery${NC}"
    local battery=$(get_battery_info)
    local bat_status=$(get_battery_status)
    local cycles=$(get_charge_cycles)
    echo -e "  Level: ${GREEN}${battery}%${NC}"
    echo -e "  Status: $bat_status"
    echo -e "  Charge Cycles: $cycles"

    # Current charge info
    local charge_info=$(get_current_charge_info)
    if [ "$charge_info" != "not_charging" ]; then
        local duration=$(echo "$charge_info" | cut -d: -f2)
        local start_bat=$(echo "$charge_info" | cut -d: -f3)
        local current_bat=$(echo "$charge_info" | cut -d: -f4)
        echo -e "  Current Charge: ${start_bat}% → ${current_bat}% ($(human_readable_time $duration))"
    fi

    # Current discharge info
    local discharge_info=$(get_current_discharge_info)
    if [ "$discharge_info" != "plugged_in" ]; then
        local duration=$(echo "$discharge_info" | cut -d: -f2)
        local start_bat=$(echo "$discharge_info" | cut -d: -f3)
        local current_bat=$(echo "$discharge_info" | cut -d: -f4)
        local used=$(echo "$discharge_info" | cut -d: -f5)
        echo -e "  Battery Life: $(human_readable_time $duration) (${used}% used)"
    fi
    echo ""

    # Session count
    if [ -f "$SESSION_LOG" ]; then
        local today=$(date +%Y-%m-%d)
        local session_count=$(grep "$today" "$SESSION_LOG" | wc -l)
        echo -e "${YELLOW}📊 Activity${NC}"
        echo -e "  Sessions today: $session_count"
        echo ""
    fi

    # Health reminder
    local today_hours=$((today_time / 3600))
    if [ $today_hours -gt 4 ]; then
        echo -e "${RED}⚠️  You've been on screen for ${today_hours}+ hours today${NC}"
        echo -e "${RED}   Consider taking a break!${NC}"
        echo ""
    fi
}

# Show detailed history
show_history() {
    local days=${1:-7}
    echo -e "${CYAN}Screen Time History (Last $days days)${NC}"
    echo ""

    if [ ! -f "$LOGFILE" ]; then
        echo "No data available"
        return
    fi

    for i in $(seq $((days - 1)) -1 0); do
        local check_date=$(date -d "$i days ago" +%Y-%m-%d)
        local total=0
        local last_on=0

        while read -r time state datetime rest; do
            local log_date=$(echo "$datetime" | cut -d' ' -f1)

            if [ "$log_date" == "$check_date" ]; then
                if [ "$state" == "on" ]; then
                    last_on=$time
                elif [ "$state" == "off" ]; then
                    if [ $last_on -ne 0 ]; then
                        local diff=$((time - last_on))
                        total=$((total + diff))
                        last_on=0
                    fi
                fi
            fi
        done <"$LOGFILE"

        local day_name=$(date -d "$i days ago" +%A)
        printf "  %-10s %-12s %s\n" "$check_date" "$day_name" "$(human_readable_time $total)"
    done
    echo ""
}

# Monitor battery events (to be run as daemon/service)
monitor_battery() {
    echo "Starting battery monitor..."
    local last_status=$(get_battery_status)

    while true; do
        sleep 60 # Check every minute

        local current_status=$(get_battery_status)

        if [ "$last_status" != "$current_status" ]; then
            if [ "$current_status" == "Charging" ]; then
                log_charge "charge_start"
                log_battery "plug"
            elif [ "$last_status" == "Charging" ]; then
                log_charge "charge_complete"
                log_battery "unplug"
            fi

            last_status="$current_status"
        fi
    done
}

# Main command handling
case "$1" in
on)
    log_screen "on"
    echo "Screen on logged"
    ;;
off)
    log_screen "off"
    echo "Screen off logged"
    ;;
plug)
    log_battery "plug"
    log_charge "charge_start"
    echo "Charging started"
    ;;
unplug)
    log_battery "unplug"
    log_charge "charge_complete"
    echo "Unplugged"
    ;;
stats | status | "")
    show_stats
    ;;
history)
    show_history "${2:-7}"
    ;;
monitor)
    monitor_battery
    ;;
today)
    local today_time=$(get_today_screentime)
    echo "Today's screen time: $(human_readable_time $today_time)"
    ;;
reset)
    echo "Are you sure you want to reset all data? (yes/no)"
    read -r confirm
    if [ "$confirm" == "yes" ]; then
        rm -f "$LOGFILE" "$BATTERY_LOG" "$CHARGE_LOG" "$SESSION_LOG" "$STATS_FILE"
        echo "All data cleared"
    else
        echo "Reset cancelled"
    fi
    ;;
help | --help | -h)
    echo "Digital Wellbeing Tracker"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  on              Log screen turned on"
    echo "  off             Log screen turned off"
    echo "  plug            Log device plugged in"
    echo "  unplug          Log device unplugged"
    echo "  stats           Show current statistics (default)"
    echo "  today           Show today's screen time only"
    echo "  history [days]  Show screen time history (default: 7 days)"
    echo "  monitor         Start battery monitoring daemon"
    echo "  reset           Clear all logged data"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Show stats"
    echo "  $0 on           # Log screen on"
    echo "  $0 history 14   # Show 14 days of history"
    echo ""
    ;;
*)
    echo "Unknown command: $1"
    echo "Use '$0 help' for usage information"
    exit 1
    ;;
esac
