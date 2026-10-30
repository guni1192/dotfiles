#!/usr/bin/env bash

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

rm -f ~/.zshenv
rm -rf $XDG_CONFIG_HOME/zsh
rm -rf $XDG_DATA_HOME/zinit/zinit.git
rm -rf $XDG_CONFIG_HOME/nvim
rm -rf $XDG_DATA_HOME/nvim/plugged
rm -f $XDG_CONFIG_HOME/herdr/config.toml
rm -rf $XDG_CONFIG_HOME/git
rm -f $HOME/.claude/settings.json
# Old setup_pnpm, setup_tmux, and setup_bin symlinks. Only a symlink is removed.
if [[ -L "$XDG_CONFIG_HOME/pnpm/rc" ]]; then
    rm -f "$XDG_CONFIG_HOME/pnpm/rc"
fi
if [[ -L "$XDG_CONFIG_HOME/tmux" ]]; then
    rm -f "$XDG_CONFIG_HOME/tmux"
fi
if [[ -L "$HOME/.local/bin/nvim-tmux" ]]; then
    rm -f "$HOME/.local/bin/nvim-tmux"
fi
rm -rf $XDG_CONFIG_HOME/aquaproj-aqua
rm -rf $XDG_DATA_HOME/aquaproj-aqua
