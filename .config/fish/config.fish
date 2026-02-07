# Run fastfetch on interactive shells
if status is-interactive
    fastfetch
end

# Initialize external tools
if type -q atuin
    atuin init fish | source
end

if type -q fzf
    fzf --fish | source
end

if type -q starship
    starship init fish | source
end

if type -q kubectl
    kubectl completion fish | source
end

if type -q eww
    eww shell-completions --shell fish | source
end

fnm env --use-on-cd | source

zoxide init fish | source
