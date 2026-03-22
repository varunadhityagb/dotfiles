#!/usr/bin/env bash

# Terminal to use with class name for floating
TERMINAL="ghostty"

# Menu options
OPTIONS="1. Update Pacman only\n2. Update AUR only\n3. Update Both (Pacman first)\n4. Select Pacman packages\n5. Select AUR packages\n6. Cancel"

# Detect AUR helper
if command -v paru &>/dev/null; then
  AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
  AUR_HELPER="yay"
else
  AUR_HELPER=""
fi

# Show menu with rofi/wofi/dmenu
if command -v rofi &>/dev/null; then
  CHOICE=$(echo -e "$OPTIONS" | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu -i -p "Update System" | cut -d'.' -f1)
elif command -v wofi &>/dev/null; then
  CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu -i -p "Update System" | cut -d'.' -f1)
else
  # Fallback to terminal menu
  CHOICE=$(echo -e "$OPTIONS" | fzf --prompt="Update System: " | cut -d'.' -f1)
fi

refresh_waybar() {
  pkill -SIGRTMIN+8 waybar
}

# Function to select and update specific Pacman packages
select_pacman_packages() {
  # Get list of available updates
  mapfile -t UPDATES < <(checkupdates 2>/dev/null)

  if [ ${#UPDATES[@]} -eq 0 ]; then
    notify-send "No Updates" "No Pacman updates available"
    return
  fi

  # Format for rofi: "package-name current-version -> new-version"
  FORMATTED_UPDATES=$(printf '%s\n' "${UPDATES[@]}")

  # Show in rofi with multi-select
  if command -v rofi &>/dev/null; then
    SELECTED=$(echo "$FORMATTED_UPDATES" | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu -multi-select -i -p "Select packages to update (Tab to select multiple)")
  elif command -v wofi &>/dev/null; then
    SELECTED=$(echo "$FORMATTED_UPDATES" | wofi --dmenu -i -p "Select packages")
  else
    SELECTED=$(echo "$FORMATTED_UPDATES" | fzf -m --prompt="Select packages: ")
  fi

  if [ -z "$SELECTED" ]; then
    return
  fi

  # Extract package names from selected items
  PACKAGES=$(echo "$SELECTED" | awk '{print $1}')

  # Confirm selection
  PACKAGE_COUNT=$(echo "$PACKAGES" | wc -l)
  PACKAGE_LIST=$(echo "$PACKAGES" | tr '\n' ' ')

  if command -v rofi &>/dev/null; then
    CONFIRM=$(echo -e "Yes\nNo" | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu -i -p "Update $PACKAGE_COUNT package(s)?")
  else
    CONFIRM="Yes"
  fi

  if [ "$CONFIRM" = "Yes" ]; then
    $TERMINAL -e bash -c "sudo pacman -S --noconfirm $PACKAGE_LIST && echo -e '\n✓ Selected packages updated. Press Enter to exit.' && read"
    refresh_waybar
  fi
}

# Function to select and update specific AUR packages
select_aur_packages() {
  if [ -z "$AUR_HELPER" ]; then
    notify-send "Update Error" "No AUR helper installed"
    return
  fi

  # Get list of available AUR updates
  mapfile -t UPDATES < <($AUR_HELPER -Qum 2>/dev/null)

  if [ ${#UPDATES[@]} -eq 0 ]; then
    notify-send "No Updates" "No AUR updates available"
    return
  fi

  # Format for rofi
  FORMATTED_UPDATES=$(printf '%s\n' "${UPDATES[@]}")

  # Show in rofi with multi-select
  if command -v rofi &>/dev/null; then
    SELECTED=$(echo "$FORMATTED_UPDATES" | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu -multi-select -i -p "Select AUR packages to update (Tab to select multiple)")
  elif command -v wofi &>/dev/null; then
    SELECTED=$(echo "$FORMATTED_UPDATES" | wofi --dmenu -i -p "Select AUR packages")
  else
    SELECTED=$(echo "$FORMATTED_UPDATES" | fzf -m --prompt="Select AUR packages: ")
  fi

  if [ -z "$SELECTED" ]; then
    return
  fi

  # Extract package names from selected items
  PACKAGES=$(echo "$SELECTED" | awk '{print $1}')

  # Confirm selection
  PACKAGE_COUNT=$(echo "$PACKAGES" | wc -l)
  PACKAGE_LIST=$(echo "$PACKAGES" | tr '\n' ' ')

  if command -v rofi &>/dev/null; then
    CONFIRM=$(echo -e "Yes\nNo" | rofi -kb-element-prev 'Ctrl+[45]' -kb-element-next 'Ctrl+[44]' -kb-mode-previous 'Ctrl+[43]' -kb-mode-next 'Ctrl+[46]' -dmenu -i -p "Update $PACKAGE_COUNT AUR package(s)?")
  else
    CONFIRM="Yes"
  fi

  if [ "$CONFIRM" = "Yes" ]; then
    $TERMINAL -e bash -c "$AUR_HELPER -S --noconfirm $PACKAGE_LIST && echo -e '\n✓ Selected AUR packages updated. Press Enter to exit.' && read"
    refresh_waybar
  fi
}

case "$CHOICE" in
1)
  $TERMINAL -e bash -c "sudo pacman -Syu --noconfirm && echo -e '\n✓ Pacman updates complete. Press Enter to exit.' && read" && refresh_waybar
  ;;
2)
  if [ -n "$AUR_HELPER" ]; then
    $TERMINAL -e bash -c "$AUR_HELPER -Sua --noconfirm && echo -e '\n✓ AUR updates complete. Press Enter to exit.' && read" && refresh_waybar
  else
    notify-send "Update Error" "No AUR helper installed"
  fi
  ;;
3)
  if [ -n "$AUR_HELPER" ]; then
    $TERMINAL -e bash -c "sudo pacman -Syu --noconfirm && $AUR_HELPER -Sua --noconfirm && echo -e '\n✓ All updates complete. Press Enter to exit.' && read" && refresh_waybar
  else
    $TERMINAL -e bash -c "sudo pacman -Syu --noconfirm && echo -e '\n✓ Pacman updates complete. Press Enter to exit.' && read" && refresh_waybar
  fi
  ;;
4)
  select_pacman_packages
  ;;
5)
  select_aur_packages
  ;;
6 | "")
  exit 0
  ;;
esac
