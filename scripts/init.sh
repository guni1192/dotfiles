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

setup_zsh() {
    ln -fsv ~/dotfiles/zshenv ~/.zshenv
    ln -fsv ~/dotfiles/zsh/ $XDG_CONFIG_HOME/zsh
    mkdir -p $XDG_DATA_HOME/zsh

    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}

setup_neovim() {
    ln -fsv ~/dotfiles/nvim/ $XDG_CONFIG_HOME/nvim
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

setup_tmux() {
    ln -fsv ~/dotfiles/tmux/ $XDG_CONFIG_HOME/tmux
}

setup_git() {
    ln -fsv ~/dotfiles/git/ $XDG_CONFIG_HOME/git
}

setup_aqua() {
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v0.6.0/aqua-installer | bash -s -- -i ~/.local/bin/aqua
    ln -fsv ~/dotfiles/aquaproj-aqua/ $XDG_CONFIG_HOME/aquaproj-aqua
    aqua --config $XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml i
}

setup_rust() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

setup_zsh
setup_neovim
setup_tmux
setup_git
setup_aqua
setup_rust
