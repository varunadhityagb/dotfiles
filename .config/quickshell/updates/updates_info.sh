#.!/usr/bin/env bash

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/qs-updates"
CACHE_DURATION=1800

# Serve cache if fresh
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [ $cache_age -lt $CACHE_DURATION ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Fresh fetch
updates_pacman=0
updates_aur=0
pacman_list=""
aur_list=""

if command -v pacman &>/dev/null; then
    pacman_list=$(checkupdates 2>/dev/null)
    updates_pacman=$(echo "$pacman_list" | sed '/^$/d' | wc -l)

    if command -v paru &>/dev/null; then
        aur_helper="paru"
    elif command -v yay &>/dev/null; then
        aur_helper="yay"
    else
        aur_helper=""
    fi

    if [ -n "$aur_helper" ]; then
        aur_list=$($aur_helper -Qum 2>/dev/null)
        updates_aur=$(echo "$aur_list" | sed '/^$/d' | wc -l)
    fi
fi

total=$((updates_pacman + updates_aur))

pacman_json="[]"
if [ -n "$pacman_list" ]; then
    pacman_json=$(echo "$pacman_list" | awk '{
        printf "%s{\"name\":\"%s\",\"from\":\"%s\",\"to\":\"%s\",\"type\":\"pacman\"}",
        (NR>1?",":""), $1, $2, $4
    }' | sed 's/^/[/' | sed 's/$/]/')
fi

aur_json="[]"
if [ -n "$aur_list" ]; then
    aur_json=$(echo "$aur_list" | awk '{
        printf "%s{\"name\":\"%s\",\"from\":\"%s\",\"to\":\"%s\",\"type\":\"aur\"}",
        (NR>1?",":""), $1, $2, $4
    }' | sed 's/^/[/' | sed 's/$/]/')
fi

output=$(printf '{"total":%d,"pacman":%d,"aur":%d,"packages":%s,"aurPackages":%s}\n' \
    "$total" "$updates_pacman" "$updates_aur" "$pacman_json" "$aur_json")

echo "$output" | tee "$CACHE_FILE"
