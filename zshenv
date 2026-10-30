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

# aqua (scripts/init.sh setup-aqua)
export AQUA_GLOBAL_CONFIG=${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml

# PATH
path_dirs=(
    /usr/local/go/bin
    $GOPATH/bin
    $HOME/.cargo/bin
    ${KREW_ROOT:-$HOME/.krew}/bin
    ${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin
    $HOME/.local/bin
    $HOME/.local/npm-global/bin
    $HOME/.antigravity/antigravity/bin
)

for dir in "${path_dirs[@]}"; do
    [[ -d "$dir" ]] && PATH="$dir:$PATH"
done
export PATH
