#!/bin/bash
set -eu

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export PATH=$HOME/.local/bin:$PATH

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_DATA_HOME

create_symlink() {
    source_file=$1
    link_name=$2
    if [[ -L "$link_name" ]]; then
        rm "$link_name"
        ln -sv "$source_file" "$link_name"
    elif [[ -e "$link_name" ]]; then
        echo "Error: A file or directory already exists with the name '$link_name'."
        exit 1
    else
        ln -sv "$source_file" "$link_name"
    fi
}

setup_zsh() {
    create_symlink ~/dotfiles/zshenv ~/.zshenv
    create_symlink ~/dotfiles/zsh/ $XDG_CONFIG_HOME/zsh

    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    if [[ -d "$ZINIT_HOME" ]]; then
        echo "zinit already installed."
    else
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi
}

setup_neovim() {
    create_symlink ~/dotfiles/nvim $XDG_CONFIG_HOME/nvim
}

setup_tmux() {
    create_symlink ~/dotfiles/tmux/ $XDG_CONFIG_HOME/tmux
}

setup_git() {
    create_symlink ~/dotfiles/git/ $XDG_CONFIG_HOME/git
}

setup_aqua() {
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v0.6.0/aqua-installer | bash -s -- -i ~/.local/bin/aqua
    ln -fsv ~/dotfiles/aquaproj-aqua/ $XDG_CONFIG_HOME/aquaproj-aqua
    aqua --config $XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml i
}

setup_rust() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

# TODO: use nix instead of aqua
# setup_nix() {
#     create_symlink ~/dotfiles/nix $XDG_CONFIG_HOME/nix
# }

setup_ghostty() {
    ln -fsv ~/dotfiles/ghostty/ $XDG_CONFIG_HOME/ghostty
}

setup_zsh
setup_neovim
setup_tmux
setup_git
setup_aqua
setup_ghostty
# setup_rust
# setup_nix
