# TeX Live paths
set -gx MANPATH /usr/local/texlive/2024/texmf-dist/doc/man $MANPATH
set -gx INFOPATH /usr/local/texlive/2024/texmf-dist/doc/info $INFOPATH
fish_add_path /usr/local/texlive/2024/bin/x86_64-linux

# User paths
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/emacs/bin
fish_add_path $HOME/.local/share/gem/ruby/3.4.0/bin
fish_add_path /usr/local/bin

# Library paths
set -gx LD_LIBRARY_PATH "$HOME/.local/lib" $LD_LIBRARY_PATH
set -gx PKG_CONFIG_PATH "$HOME/.local/lib/pkgconfig" $PKG_CONFIG_PATH

# Application paths
fish_add_path $HOME/.local/share/coursier/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /var/lib/flatpak/exports/bin
fish_add_path /.local/share/flatpak/exports/bin
fish_add_path $HOME/Softwares/ideaIU-2024.2.4/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/development/flutter/bin

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Other environment variables
set -gx LIBVIRT_DEFAULT_URI "qemu:///system"
set -gx EDITOR emacsclient
set -gx MESA_LOADER_DRIVER_OVERRIDE iris
set -gx OPENCV_LOG_LEVEL ERROR
set -gx DOCKER_HOST unix:///var/run/docker.sock

set -x QT_QPA_PLATFORMTHEME qt6ct
set -x QT_QPA_PLATFORMTHEME_QT5 qt5ct

# dont stage these
set -gx ANTHROPIC_API_KEY "78704e3c94ab4bf3bdbd50b69a8c772b.n37zhJodlsfopa8N-q3NoqNc"
set -gx ANTHROPIC_BASE_URL "https://ollama.com"
