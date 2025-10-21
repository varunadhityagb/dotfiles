# Add TeX Live documentation to MANPATH and INFOPATH
export MANPATH="/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH"

# Add TeX Live binaries to PATH
export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export PATH=$HOME/.config/emacs/bin:$PATH
export PATH=$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH


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
export EDITOR=nvim
export VISUAL=nvim
alias nvimdiff='nvim -d'

nitch

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

alias tree='tree -CAhF --dirsfirst'


eval "$(atuin init zsh)"
alias icat="kitten icat"
alias mysql="mysql --host=127.0.0.1 --port=3306"
source <(fzf --zsh)


source <(starship init zsh)

# . "/home/varunadhityagb/.deno/env"


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


function mhd() {
    sudo mkdir -p /run/media/varunadhityagb/Additional\ Disk/
    sudo mount /dev/sda1 /run/media/varunadhityagb/Additional\ Disk/
}

function umhd() {
    sudo umount /dev/sda1
}
export QT_QPA_PLATFORMTHEME=qt5ct

function winboat() {
  /home/varunadhityagb/AppImages/winboat-0.6.13.AppImage & disown
}

function get_timetable() {
    if [[ -z $1 ]]; then 
        ~/random_scripts/timetable.sh 2023 aie e 5
    elif [[ $1 == +* ]]; then
        ~/random_scripts/timetable.sh 2023 aie e 5 $1
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

if [ -z "$SSH_AUTH_SOCK" ] || ! ssh-add -l &>/dev/null; then
    eval $(keychain --quiet --eval ~/.ssh/id_ed25519)
fi

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


get_amrita_photo() {
  if [ -z "$1" ]; then
    echo "Usage: get_amrita_photo <ROLL_NO>"
    return 1
  fi

  ROLL_NO="$1"
  
  if [ -z "$2" ]; then 
      curl -sS -X GET "https://my.amrita.edu/icts/admn_port_down/profpic_student.php?roll_no=${ROLL_NO}" \
        -H 'Accept: image/avif,image/webp,image/apng,image/*,*/*;q=0.8' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) Chrome/138.0.0.0 Safari/537.36' \
        -H 'Cookie: PHPSESSID=veqnujlek0r5mjs5s76g0h9j91' \
        -H 'Host: my.amrita.edu' \
        -H 'Referer: https://students.amrita.edu/' \
        --compressed | icat
  else
      curl --output "$1.jpeg" -sS -X GET "https://my.amrita.edu/icts/admn_port_down/profpic_student.php?roll_no=${ROLL_NO}" \
        -H 'Accept: image/avif,image/webp,image/apng,image/*,*/*;q=0.8' \
        -H 'Accept-Encoding: gzip, deflate, br, zstd' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) Chrome/138.0.0.0 Safari/537.36' \
        -H 'Cookie: PHPSESSID=veqnujlek0r5mjs5s76g0h9j91' \
        -H 'Host: my.amrita.edu' \
        -H 'Referer: https://students.amrita.edu/' \
        --compressed
  fi
}


summarize_dir() {
for i in $(ls); do
       echo "==================================";
       echo "$i";
       echo "==================================";
       cat "$i";
 done;
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
alias hy="hyprctl"
alias list_packages_by_time="ls -lt /var/lib/pacman/local | awk '{print $9}'
"

export MESA_LOADER_DRIVER_OVERRIDE=iris
