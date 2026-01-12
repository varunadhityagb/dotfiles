# Add TeX Live documentation to MANPATH and INFOPATH
export MANPATH="/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"

# Add TeX Live binaries to PATH
export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export PATH=$HOME/.config/emacs/bin:$PATH
export PATH=$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH

export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(git z thefuck qrcode themes)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

# path=('/home/varunadhityagb/.juliaup/bin' $path)
# export PATH
# <<< juliaup initialize <<<
#

export PATH="$PATH:/home/varunadhityagb/.local/share/coursier/bin"

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:/.local/share/flatpak/exports/bin"

export PATH=$PATH:"$HOME/Softwares/ideaIU-2024.2.4/bin/"

export PATH=$PATH:/home/varunadhityagb/.spicetify

export PATH="$HOME/development/flutter/bin:$PATH"

# bun completions
[ -s "/home/varunadhityagb/.bun/_bun" ] && source "/home/varunadhityagb/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export LIBVIRT_DEFAULT_URI="qemu:///system"

# Set the default editor
export EDITOR=emacsclient
alias nvimdiff='nvim -d'

fastfetch

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

alias tree='tree -CAhF --dirsfirst'


eval "$(atuin init zsh)"
alias icat="kitten icat"
alias mysql="mysql --host=127.0.0.1 --port=3306"
source <(fzf --zsh)
source <(eww shell-completions --shell zsh)


source <(starship init zsh)

# . "/home/varunadhityagb/.deno/env"


#for matlab to use gpu
export MESA_LOADER_DRIVER_OVERRIDE=i965
autoload -U compinit; compinit
export DOCKER_HOST=unix:///var/run/docker.sock


function mhd() {
    sudo mkdir -p /run/media/varunadhityagb/Additional\ Disk/
    sudo mount /dev/sda1 /run/media/varunadhityagb/Additional\ Disk/
}

function umhd() {
    sudo umount /dev/sda1
}
# export QT_QPA_PLATFORMTHEME=qt5ct


function get_timetable() {
    if [[ -z $1 ]]; then 
        ~/random_scripts/timetable.sh 2023 aie-e 6
    elif [[ $1 == +* || $1 == -* ]]; then
        ~/random_scripts/timetable.sh 2023 aie-e 6 $1
    else
        ~/random_scripts/timetable.sh $1 $2 $3 $4
    fi
}

function get_attendence() {
    /home/varunadhityagb/gitclonestuff/myamrita-parser/.venv/bin/python /home/varunadhityagb/gitclonestuff/myamrita-parser/my-amrita-attendence.py
}

function get_marks() {
    /home/varunadhityagb/gitclonestuff/myamrita-parser/.venv/bin/python /home/varunadhityagb/gitclonestuff/myamrita-parser/my-amrita-marks.py
}

function amrita_update_session() {
    /home/varunadhityagb/gitclonestuff/myamrita-parser/.venv/bin/python /home/varunadhityagb/gitclonestuff/myamrita-parser/my-amrita-login.py
}

function no_sleep(){
(
        notify-send "🛑 No Sleep Mode" "Lid close will NOT suspend the system."
        systemd-inhibit --what=handle-lid-switch --who="Hyprland" --why="Temporarily disabling lid sleep" bash
    ) &
}

# if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
#     eval $(keychain --quiet --eval ~/.ssh/id_ed25519)
# fi

function ocli() { 
    user=$2
    create_user="CREATE USER $user IDENTIFIED BY oraclesucks
        DEFAULT TABLESPACE users
        TEMPORARY TABLESPACE temp
        QUOTA UNLIMITED ON users;"

    allow_login="GRANT CREATE SESSION TO $user;"
    give_dev_prev="GRANT CONNECT, RESOURCE TO $user;"
    del_user="DROP USER $user CASCADE;"

    if [[ $1 == "-n" ]]; then
        sqlplus -s system/oraclesucks <<EOF
        ${create_user}
        ${allow_login}
        ${give_dev_prev}
        EXIT;
EOF
    elif [[ $2 == "-d" ]]; then
        sqlplus -s system/oraclesucks <<EOF
        DROP USER $user CASCADE;
        EXIT;
EOF
    fi
}



file_types=()           # Array for file type filters (leave empty to include all)

summarize_dir() {
    exclude=("$@")          # Exclude directories passed as arguments

    for item in *; do
            if [ -f "$item" ]; then
                if _is_included_file_type "$item"; then
                    echo "=================================="
                    echo "$item"
                    echo "=================================="
                    cat "$item"
                    echo -e "\n\n"
                fi
            fi
        done

    for i in */; do
        dir="${i%/}"

        skip=false
        for ex in "${exclude[@]}"; do
            if [ "$dir" = "$ex" ]; then
                skip=true
                break
            fi
        done

        if [ "$skip" = true ]; then
            continue
        fi

        _summarize_recursive "$dir"
    done
}

_summarize_recursive() {
    for item in "$1"/*; do
        if [ -d "$item" ]; then
            _summarize_recursive "$item"
        else
            # Check if file extension matches allowed file types (if any)
            if _is_included_file_type "$item"; then
                echo "=================================="
                echo "$item"
                echo "=================================="
                cat "$item"
                echo -e "\n\n"
            fi
        fi
    done
}

_is_included_file_type() {
    # If no file types are specified, include all files
    if [ ${#file_types[@]} -eq 0 ]; then
        return 0
    fi

    # Check if the file extension is in the allowed list
    for ext in "${file_types[@]}"; do
        if [[ "$1" == *.$ext ]]; then
            return 0
        fi
    done

    # If no match, exclude the file
    return 1
}

get_group_id() {mudslide groups 2>/dev/null | grep "$1" | jq -r '.id'}

send_whatsapp_msg() { mudslide send $(get_group_id "$1") $2 }

http_status(){
  for port in "$@"; do
    curl -s https://http.cat/$port | icat
  done
}

tscale() {
    sudo tailscale down
    if [[ $# == 0 ]]; then
      sudo tailscale up --accept-dns=true --accept-routes=false
    elif [[ $1 == 1 ]]; then
      sudo tailscale up --accept-dns=true --accept-routes=true
    fi

}

source <(kubectl completion zsh)

alias ssh="kitty +kitten ssh"
alias cp='~/gitclonestuff/advcpmv/advcp  -g'
alias mv='~/gitclonestuff/advcpmv/advmv  -g'
alias i="yay -S"
alias is="yay -Ss"
alias fzf="fzf --preview='bat --color=always {}'" 
alias archdays='echo $(( ( $(date +%s) - $(date -d "$(sudo tune2fs -l /dev/nvme0n1p1 | grep "Filesystem created" | awk "{print \$3, \$4, \$5, \$6, \$7}")" +%s) ) / 86400 ))'
alias pyact="source .venv/bin/activate"
alias ppt2pdf="libreoffice --headless --convert-to pdf"
alias emacsd="emacs --daemon"
alias ls="lsd"
alias l="lsd -l"
alias list_packages_by_time="lsd -lt /var/lib/pacman/local | awk '{print $9}'"
alias em="emacsclient"
alias i="yay -S"
alias s="yay -Ss"

export MESA_LOADER_DRIVER_OVERRIDE=iris

load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  unfunction nvm node npm npx 2>/dev/null
}

load_bun() {
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  # Load bun completions only when needed
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
  unfunction bun 2>/dev/null
}


# ----- NVM lazy shims -----
nvm()  { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm()  { load_nvm; npm "$@"; }
npx()  { load_nvm; npx "$@"; }

# ----- Bun lazy shim -----
bun()  { load_bun; bun "$@"; }

autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
# export QT_PLUGIN_PATH=/usr/lib/qt/plugins
