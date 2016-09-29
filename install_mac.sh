#! /bin/bash

ln -s ~/dotfiles/.zshrc_mac ~/.zshrc
ln -s ~/dotfiles/.tmux ~/.tmux
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.emacs.el ~/.emacs.el

if [ "$(uname)" == 'Darwin' ]; then
    # OS = Mac
    cp custom_font/* /Library/Fonts/
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    # OS = Linux
    cp custom_font/* ~/.fonts/
    fc-cache -fv
fi

