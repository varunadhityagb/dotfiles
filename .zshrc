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

alias sem1="cd ~/OneDrive/COLLEGE/Sem1"
alias sem2="cd ~/OneDrive/COLLEGE/Sem2"
alias sem3="cd ~/OneDrive/COLLEGE/Sem3"
alias sem4="cd ~/OneDrive/COLLEGE/Sem4"
alias sem="cd ~/OneDrive/COLLEGE/Sem4"



export LIBVIRT_DEFAULT_URI="qemu:///system"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/varunadhityagb/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/varunadhityagb/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
#

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'
alias nvimdiff='nvim -d'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias cls='clear'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '


# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Show open ports
alias openports='netstat -nape --inet'

alias tree='tree -CAhF --dirsfirst'

# Alias's for archives
alias mktar='tar -cvf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}



eval "$(atuin init zsh)"
alias icat="kitten icat"
alias em="emacsclient -a 'emacs'"
alias jn="jupyter notebook"
alias jb="jupyter lab"
alias emdoom="emacs ~/.config/doom/ &"
export PATH=$PATH:/home/varunadhityagb/.spicetify
source <(fzf --zsh)


source <(starship init zsh)

eval $(keychain --eval --agents ssh ~/.ssh/id_ed25519)

# . "/home/varunadhityagb/.deno/env"
