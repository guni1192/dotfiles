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
  # Vim
  if [ -e $HOME/.vim ]; then
    rm -rf ~/.vim
  fi
  mkdir $HOME/.vim
  ln -s ~/dotfiles/vim/config ~/.vim/config
  # NeoVim
  ln -s ~/dotfiles/nvim ~/.config/nvim
  # ideavim
  ln -s ~/dotfiles/.ideavimrc ~/.ideavimrc

}

if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

  if [ ! -e $HOME/.config ]; then
    mkdir ~/.config
  fi

  setup_zsh

  setup_vim

  cp ~/dotfiles/gitconfig ~/.gitconfig

  # tmux
  ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

  read -p "Do you use X11?[y/n] " yn ;
  case $yn in
    [Yy]* ) {
      # i3 Window Manager
      echo "i3wm linking ..."
      ln -s ~/dotfiles/i3 ~/.config/i3/
      echo "Xresources linking ..."
      ln -s ~/dotfiles/.Xresources ~/.Xresources

      # polybar
      echo "polybar linking ..."
      ln -s ~/dotfiles/polybar ~/.config/polybar/
    };;
  esac

elif [ "$(expr substr $(uname -s) 1 5)" == 'Darwin' ]; then

  setup_zsh

  setup_vim

  cp ~/dotfiles/gitconfig ~/.gitconfig

  # tmux
  ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

