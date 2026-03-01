#!/usr/bin/env bash

# Cache file to store results
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-updates"
CACHE_DURATION=1800 # 30 minutes in seconds

# Check if command exists
_checkCommandExists() {
  command -v "$1" &>/dev/null
}

# Check for lock files with timeout
check_lock_files() {
  local pacman_lock="/var/lib/pacman/db.lck"
  local checkup_lock="${TMPDIR:-/tmp}/checkup-db-${UID}/db.lck"
  local timeout=60
  local elapsed=0

  while [ -f "$pacman_lock" ] || [ -f "$checkup_lock" ]; do
    if [ $elapsed -ge $timeout ]; then
      echo '{"text": "⏳", "tooltip": "Update check locked", "class": "yellow"}' >&2
      exit 1
    fi
    sleep 1
    ((elapsed++))
  done
}

# Use cached result if fresh enough
if [ -f "$CACHE_FILE" ]; then
  cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
  if [ $cache_age -lt $CACHE_DURATION ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# Thresholds for color indicators
threshhold_green=0
threshhold_yellow=25
threshhold_red=100

updates_pacman=0
updates_aur=0

# Check for updates based on distro
if _checkCommandExists "pacman"; then
  check_lock_files

  # Get pacman updates
  updates_pacman=$(checkupdates 2>/dev/null | wc -l)

  # Detect AUR helper
  if _checkCommandExists "paru"; then
    aur_helper="paru"
  elif _checkCommandExists "yay"; then
    aur_helper="yay"
  else
    aur_helper=""
  fi

  # Get AUR updates
  if [ -n "$aur_helper" ]; then
    updates_aur=$($aur_helper -Qum 2>/dev/null | wc -l)
  fi

elif _checkCommandExists "dnf"; then
  updates_pacman=$(dnf check-update -q 2>/dev/null | grep -c '^[a-z0-9]' || echo 0)
fi

updates=$((updates_pacman + updates_aur))

# Determine CSS class
css_class="green"
if [ "$updates" -gt $threshhold_red ]; then
  css_class="red"
elif [ "$updates" -gt $threshhold_yellow ]; then
  css_class="yellow"
fi

# Build tooltip with breakdown
if [ "$updates" -gt 0 ]; then
  tooltip="Total: $updates updates"
  if [ "$updates_pacman" -gt 0 ] && [ "$updates_aur" -gt 0 ]; then
    tooltip="$updates updates (Pacman: $updates_pacman, AUR: $updates_aur)"
  elif [ "$updates_pacman" -gt 0 ]; then
    tooltip="$updates_pacman Pacman updates"
  elif [ "$updates_aur" -gt 0 ]; then
    tooltip="$updates_aur AUR updates"
  fi
else
  tooltip="No updates available"
fi

# Generate output
if [ "$updates" -gt 0 ]; then
  output=$(printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
    "$updates" "$updates" "$tooltip" "$css_class")
else
  output='{"text": "", "alt": "0", "tooltip": "No updates available", "class": "green"}'
fi

# Save to cache and output
echo "$output" | tee "$CACHE_FILE"
