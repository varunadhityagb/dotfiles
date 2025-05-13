# Add TeX Live documentation to MANPATH and INFOPATH
export MANPATH="/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"

# Add TeX Live binaries to PATH
export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/.config/emacs/bin:$PATH

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(git z thefuck qrcode themes)

source $ZSH/oh-my-zsh.sh

export PATH="$PATH:/home/varunadhityagb/.local/share/coursier/bin"

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"

export PATH=$PATH:"$HOME/Softwares/ideaIU-2024.2.4/bin/"

alias ssh="kitty +kitten ssh"


export LIBVIRT_DEFAULT_URI="qemu:///system"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/varunadhityagb/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/varunadhityagb/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/varunadhityagb/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/varunadhityagb/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
 
eval "conda activate base"
# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/varunadhityagb/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
#

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias nvimdiff='nvim -d'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

alias tree='tree -CAhF --dirsfirst'


# eval "$(atuin init zsh)"
alias icat="kitten icat"
alias mysql="mysql --host=127.0.0.1 --port=3306"
export PATH=$PATH:/home/varunadhityagb/.spicetify
source <(fzf --zsh)


source <(starship init zsh)

eval $(keychain --eval --agents ssh ~/.ssh/id_ed25519)

# . "/home/varunadhityagb/.deno/env"

# bun completions
[ -s "/home/varunadhityagb/.bun/_bun" ] && source "/home/varunadhityagb/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#for matlab to use gpu
export MESA_LOADER_DRIVER_OVERRIDE=i965

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
autoload -U compinit; compinit
export DOCKER_HOST=unix:///var/run/docker.sock


function swwc() {
    # swww img $1
    wal -i $1

    killall hyprpaper
    echo "preload = $1\nwallpaper = ,$1\nsplash = false" > ~/.config/hypr/hyprpaper.conf
    hyprpaper & disown

    cat ~/.config/zathura/base > ~/.config/zathura/zathurarc
    cat ~/.cache/wal/colors-zathura >> ~/.config/zathura/zathurarc

    echo "path = $1" > ~/.config/hypr/wall.conf
    ~/.pywal/generate-theme.sh
}


function mhd() {
    sudo mkdir -p /run/media/varunadhityagb/Additional\ Disk/
    sudo mount /dev/sda1 /run/media/varunadhityagb/Additional\ Disk/
}

function umhd() {
    sudo umount /dev/sda1
}
export QT_QPA_PLATFORMTHEME=qt5ct

function get_atendence() {
    /home/varunadhityagb/anaconda3/bin/python /home/varunadhityagb/gitclonestuff/myamrita-parser/my-amrita-attendence.py
}

function no_sleep(){
(
        notify-send "🛑 No Sleep Mode" "Lid close will NOT suspend the system."
        systemd-inhibit --what=handle-lid-switch --who="Hyprland" --why="Temporarily disabling lid sleep" bash
    ) &
}
export PATH="$HOME/development/flutter/bin:$PATH"
