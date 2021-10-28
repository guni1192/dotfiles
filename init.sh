#!/bin/bash

set -eu

setup_zsh() {
    rm -rf ~/.zsh

    ln -fsv ~/dotfiles/zsh ~/.zsh
    ln -fsv ~/.zsh/.zshrc ~/.zshrc
    ln -fsv ~/.zsh/.zshenv ~/.zshenv
}

setup_vim() {
    rm -rf ~/.vim/config
    mkdir -p ~/.vim

    ln -fsv ~/dotfiles/vimrc ~/.vimrc
    ln -fsv ~/dotfiles/vim ~/.vim/config
}

setup_neovim() {
    mkdir -p ~/.config/nvim

    ln -fsv ~/dotfiles/init.vim ~/.config/nvim/init.vim
}


# read -p "Do you use X11?[y/n] " yn ;
# case $yn in
#     [Yy]* ) {
#         # i3 Window Manager
#         echo "i3wm linking ..."
#         ln -sv ~/dotfiles/i3 ~/.config/i3/
#         echo "Xresources linking ..."
#         ln -sv ~/dotfiles/.Xresources ~/.Xresources
#         echo "alacritty linking ..."
#         ln -sv ~/dotfiles/alacritty ~/.config/alacritty
#         # polybar
#         echo "polybar linking ..."
#         ln -sv ~/dotfiles/polybar ~/.config/polybar/
#     };;
# esac


mkdir -p $HOME/.config

setup_zsh
setup_vim
setup_neovim

ln -fsv ~/dotfiles/gitconfig ~/.gitconfig
ln -fsv ~/dotfiles/.tmux.conf ~/.tmux.conf
