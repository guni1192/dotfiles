#!/bin/bash

set -eu

setup_zsh() {
    if [ -e $HOME/.zsh ]; then
        rm -rf ~/.zsh
    fi
    ln -sv ~/dotfiles/zsh ~/.zsh
    ln -sv ~/.zsh/.zshrc ~/.zshrc
    ln -sv ~/.zsh/.zshenv ~/.zshenv
}

setup_vim() {
    ln -sv ~/dotfiles/vimrc ~/.vimrc
    if [ ! -e ~/.vim ]; then
        mkdir  ~/.vim
    fi
    ln -sv ~/dotfiles/vim ~/.vim/config
}

if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

    if [ ! -e $HOME/.config ]; then
        mkdir $HOME/.config
    fi

    read -p "Do you use X11?[y/n] " yn ;
    case $yn in
        [Yy]* ) {
            # i3 Window Manager
            echo "i3wm linking ..."
            ln -sv ~/dotfiles/i3 ~/.config/i3/
            echo "Xresources linking ..."
            ln -sv ~/dotfiles/.Xresources ~/.Xresources

        # polybar
        echo "polybar linking ..."
        ln -sv ~/dotfiles/polybar ~/.config/polybar/
        };;
    esac

elif [ "$(expr substr $(uname -s) 1 5)" == 'Darwin' ]; then
    echo "setup macOS"

else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

setup_zsh
setup_vim

ln -sv ~/dotfiles/gitconfig ~/.gitconfig
ln -sv ~/dotfiles/.tmux.conf ~/.tmux.conf

