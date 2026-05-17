#!/bin/bash
set -euo pipefail

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export PATH=$HOME/.local/bin:$PATH

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_DATA_HOME

create_symlink() {
    source_file=$1
    link_name=$2
    if [[ -L "$link_name" ]]; then
        rm "$link_name"
        ln -sv "$source_file" "$link_name"
    elif [[ -e "$link_name" ]]; then
        echo "Error: A file or directory already exists with the name '$link_name'."
        exit 1
    else
        ln -sv "$source_file" "$link_name"
    fi
}

setup_zsh() {
    create_symlink ~/dotfiles/zshenv ~/.zshenv
    create_symlink ~/dotfiles/zsh/ $XDG_CONFIG_HOME/zsh

    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    if [[ -d "$ZINIT_HOME" ]]; then
        echo "zinit already installed."
    else
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi
}

setup_neovim() {
    create_symlink ~/dotfiles/nvim $XDG_CONFIG_HOME/nvim
}

setup_tmux() {
    create_symlink ~/dotfiles/tmux/ $XDG_CONFIG_HOME/tmux
}

setup_git() {
    create_symlink ~/dotfiles/git/ $XDG_CONFIG_HOME/git
}

load_nix_env() {
    # Source whichever nix profile script exists so `nix` is on PATH even in
    # non-login shells (e.g. devcontainer postCreateCommand).
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        # shellcheck disable=SC1091
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

install_nix_determinate() {
    # Determinate installer running upstream Nix CE — we deliberately skip
    # `--determinate` so the installer uses nixbld gid 30000 (upstream default)
    # rather than 350, which collides with groups left behind by previous
    # upstream installs.
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
        | sh -s -- install --no-confirm
}

install_nix_single_user() {
    # No-systemd / container path: upstream installer in single-user mode, no
    # daemon, profile lives under ~/.nix-profile.
    mkdir -p "$HOME/.config/nix"
    grep -q '^experimental-features' "$HOME/.config/nix/nix.conf" 2>/dev/null \
        || echo 'experimental-features = nix-command flakes' \
            >> "$HOME/.config/nix/nix.conf"
    curl -fsSL https://nixos.org/nix/install -o /tmp/nix-install.sh
    sh /tmp/nix-install.sh --no-daemon --yes
    rm -f /tmp/nix-install.sh
}

setup_nix() {
    load_nix_env
    if command -v nix >/dev/null 2>&1; then
        echo "nix already installed: $(nix --version)"
        return
    fi

    case "$(uname -s)" in
        Darwin) install_nix_determinate ;;
        Linux)
            if [[ -d /run/systemd/system ]]; then
                install_nix_determinate
            else
                install_nix_single_user
            fi
            ;;
        *)
            echo "Unsupported OS: $(uname -s)" >&2
            exit 1
            ;;
    esac

    load_nix_env
}

setup_devbox() {
    if command -v devbox >/dev/null 2>&1; then
        echo "devbox already installed: $(devbox version)"
    else
        echo "Installing Devbox..."
        curl -fsSL https://get.jetify.com/devbox | bash -s -- -f
    fi

    # Symlink devbox.json/devbox.lock individually instead of the whole
    # directory so per-environment .devbox/ state (absolute /nix/store paths)
    # stays local to each host/container and doesn't leak via bind mounts.
    local global_dir="$XDG_DATA_HOME/devbox/global/default"
    rm -rf "$global_dir"
    mkdir -p "$global_dir"
    create_symlink ~/dotfiles/devbox/devbox.json "$global_dir/devbox.json"
    create_symlink ~/dotfiles/devbox/devbox.lock "$global_dir/devbox.lock"

    devbox global install

    # Evaluate the init_hook once so the npm copilot-language-server install
    # runs here, not on every interactive shell start.
    eval "$(devbox global shellenv --init-hook)" >/dev/null 2>&1 || true
}

setup_rust() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

setup_ghostty() {
    create_symlink ~/dotfiles/ghostty/ $XDG_CONFIG_HOME/ghostty
}

setup_all() {
    setup_zsh
    setup_neovim
    setup_tmux
    setup_git
    setup_nix
    setup_devbox
    setup_ghostty
}

usage() {
    cat <<'EOF'
Usage: scripts/init.sh <subcommand>

Subcommands:
  setup-all       Run every step below (default order, excludes setup-rust).
  setup-zsh       Symlink zshenv + zsh config and clone zinit.
  setup-neovim    Symlink neovim config.
  setup-tmux      Symlink tmux config.
  setup-git       Symlink git config.
  setup-nix       Install Nix (Determinate on macOS / systemd-Linux,
                  upstream single-user on no-systemd Linux).
  setup-devbox    Install Devbox and apply the dotfiles global profile.
  setup-ghostty   Symlink ghostty config.
  setup-rust      Install rustup + stable toolchain (not part of setup-all).

All steps are idempotent.
EOF
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    case "$1" in
        -h|--help|help)
            usage
            return
            ;;
    esac

    # setup-foo → setup_foo, dispatched only if defined as a function. This
    # keeps the subcommand list and the function names in lockstep — no
    # separate case arms to drift from the usage text.
    local fn="${1//-/_}"
    if [[ "$1" == setup-* ]] && declare -F "$fn" >/dev/null; then
        "$fn"
    else
        echo "Unknown subcommand: $1" >&2
        echo >&2
        usage >&2
        exit 1
    fi
}

main "$@"
