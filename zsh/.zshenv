# General
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export EDITOR=nvim

# Shell
export ZDOTDIR="${HOME}/.zsh"

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# export GO111MODULE=auto

export PATH=$HOME/.cargo/bin:/usr/local/go/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH
