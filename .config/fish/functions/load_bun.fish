function load_bun
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
    #test -s "$BUN_INSTALL/_bun"; and source "$BUN_INSTALL/_bun"
    functions -e bun 2>/dev/null
end
