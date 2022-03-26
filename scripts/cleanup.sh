#!/usr/bin/env bash

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

rm -f ~/.zshenv
rm -rf $XDG_CONFIG_HOME/zsh
rm -rf $XDG_CONFIG_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim/plugged
rm -rf $XDG_CONFIG_HOME/tmux
rm -rf $XDG_CONFIG_HOME/git
rm -rf $XDG_CONFIG_HOME/aquaproj-aqua
