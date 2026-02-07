if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec start-hyprland
  export GNOME_KEYRING_CONTROL
  export GNOME_KEYRING_PID
  export SSH_AUTH_SOCK
fi

