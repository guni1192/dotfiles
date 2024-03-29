# General
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export EDITOR=nvim

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Shell
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# export GO111MODULE=auto

# Rust
. "$HOME/.cargo/env"

export PATH=$HOME/.cargo/bin:/usr/local/go/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.local/bin:$PATH

# aqua
export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
export AQUA_GLOBAL_CONFIG=${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml

case ${OSTYPE} in
    darwin*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
    linux*)
        ;;
esac

