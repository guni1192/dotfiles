#!/bin/bash
set -eu

export XDG_CONFIG_HOME=$HOME/.config
mkdir -p $XDG_CONFIG_HOME

setup_zsh() {
    ln -fsv ~/dotfiles/zshenv ~/.zshenv
    ln -fsv ~/dotfiles/zsh/ $XDG_CONFIG_HOME/zsh
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

setup_zsh
setup_neovim
setup_tmux
setup_git
