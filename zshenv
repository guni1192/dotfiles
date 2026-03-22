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

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

case ${OSTYPE} in
    darwin*)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
    linux*)
        ;;
esac

# PATH
path_dirs=(
    /opt/homebrew/opt/llvm/bin
    /usr/local/go/bin
    $GOPATH/bin
    $HOME/.cargo/bin
    ${KREW_ROOT:-$HOME/.krew}/bin
    $HOME/.local/bin
    $HOME/.local/share/mise/shims
    $HOME/.antigravity/antigravity/bin
)

for dir in "${path_dirs[@]}"; do
    [[ -d "$dir" ]] && PATH="$dir:$PATH"
done
export PATH
