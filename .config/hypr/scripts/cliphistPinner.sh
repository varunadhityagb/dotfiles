#!/bin/bash

# File to store pinned items
PINNED_FILE="$HOME/.cliphist_pinned"
DELIMITER="---"

# Ensure pinned file exists
touch "$PINNED_FILE"

# Function to pin an item
pin_item() {
    local item="$1"
    if [[ -z "$item" ]]; then
        echo "No item provided to pin."
        return
    fi
    # Check if the item is already pinned
    if awk -v RS="$DELIMITER" -v item="$item" '$0 ~ item { found=1 } END { exit !found }' "$PINNED_FILE"; then
        echo "Item is already pinned."
    else
        echo -e "$DELIMITER\n$item\n$DELIMITER" >> "$PINNED_FILE"
        echo "Pinned: (multiline item)"
    fi
}

# Function to unpin an item
unpin_item() {
    local item="$1"
    if [[ -z "$item" ]]; then
        echo "No item provided to unpin."
        return
    fi
    # Find and remove the item including delimiters
    awk -v item="$item" -v RS="$DELIMITER" -v ORS="$DELIMITER" 'index($0, item) == 0' "$PINNED_FILE" > "$PINNED_FILE.tmp" && mv "$PINNED_FILE.tmp" "$PINNED_FILE"
    echo "Unpinned: (multiline item)"
}

# Function to list all pinned items without delimiters
list_pinned() {
    echo "Pinned items:"
    awk -v RS="$DELIMITER" 'NF { print $0 "\n" }' "$PINNED_FILE"
}

# Function to remove all pinned items
delete_pinned() {
   echo "Deleting all pinned items:"
   cat "$PINNED_FILE"
   echo "" > "$PINNED_FILE"
}

# Main script logic
case "$1" in
    pin)
        pin_item "$2"
        ;;
    unpin)
        unpin_item "$2"
        ;;
    list)
        list_pinned
        ;;
    del)
        delete_pinned
        ;;
    *)
        echo "Usage: $0 {pin|unpin|list|del} [item]"
        exit 1
        ;;
esac

