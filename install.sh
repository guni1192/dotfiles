#! /bin/bash
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.oh-my-zsh ~/.oh-my-zsh

if [ "$(uname)" == 'Darwin' ]; then
    # OS = Mac
    cp custom_font/* /Library/Fonts/
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    # OS = Linux
    cp custom_font/* ~/.fonts/
    fc-cache -fv
fi

# zsh install 
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

