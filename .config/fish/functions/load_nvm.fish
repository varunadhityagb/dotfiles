function load_nvm
    set -gx NVM_DIR "$HOME/.nvm"
    test -s "$NVM_DIR/nvm.sh"; and source "$NVM_DIR/nvm.sh"
    test -s "$NVM_DIR/bash_completion"; and source "$NVM_DIR/bash_completion"
    functions -e nvm node npm npx 2>/dev/null
end
