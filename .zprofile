if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec start-hyprland
  export GNOME_KEYRING_CONTROL
  export GNOME_KEYRING_PID
  export SSH_AUTH_SOCK
fi

if [ -f ~/.config/gnome-keyring.tpm2 ]
then
    if ! [ -S /run/user/$UID/keyring/control ]
    then
      gnome-keyring-daemon --start --components=secrets
    fi
    doas -u tss /usr/bin/clevis-decrypt-tpm2 < .config/gnome-keyring.tpm2 | ~/bin/unlock.py
fi
