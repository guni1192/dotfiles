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

setup_nix() {
    load_nix_env
    if command -v nix >/dev/null 2>&1; then
        echo "nix already installed: $(nix --version)"
        return
    fi

    # We use Determinate's installer (better install/uninstall UX) but install
    # upstream Nix CE (no `--determinate` flag). Determinate Nix would otherwise
    # require nixbld gid 350, which conflicts with the upstream default gid
    # 30000 left behind by previous installs.
    case "$(uname -s)" in
        Darwin)
            echo "Installing Nix (upstream, macOS multi-user)..."
            curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
                | sh -s -- install --no-confirm
            ;;
        Linux)
            if [[ -d /run/systemd/system ]]; then
                echo "Installing Nix (upstream, Linux multi-user)..."
                curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
                    | sh -s -- install --no-confirm
            else
                # Container / no-systemd: fall back to upstream single-user installer.
                # No daemon is required and the install lives under ~/.nix-profile.
                echo "Installing Nix (upstream single-user, no systemd)..."
                mkdir -p "$HOME/.config/nix"
                grep -q '^experimental-features' "$HOME/.config/nix/nix.conf" 2>/dev/null \
                    || echo 'experimental-features = nix-command flakes' \
                        >> "$HOME/.config/nix/nix.conf"
                curl -fsSL https://nixos.org/nix/install -o /tmp/nix-install.sh
                sh /tmp/nix-install.sh --no-daemon --yes
                rm -f /tmp/nix-install.sh
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

    # Apply the dotfiles devbox.json as the user's global profile.
    # Symlink the source files individually (not the whole directory) so that
    # devbox's per-environment state under .devbox/ — which contains absolute
    # /nix/store paths — stays local to each host/container instead of leaking
    # through the bind mount.
    local global_dir="$XDG_DATA_HOME/devbox/global/default"
    if [[ -L "$global_dir" ]]; then
        rm "$global_dir"
    fi
    mkdir -p "$global_dir"
    create_symlink ~/dotfiles/devbox/devbox.json "$global_dir/devbox.json"
    create_symlink ~/dotfiles/devbox/devbox.lock "$global_dir/devbox.lock"

    # Materialize the packages defined in devbox/devbox.json.
    # `devbox global install` is itself idempotent: it skips packages already
    # present in the global profile.
    devbox global install

    # Run the devbox init_hook once (covers `npm install -g
    # @github/copilot-language-server`). Interactive shells then activate the
    # profile with plain `devbox global shellenv` and don't depend on the
    # generated .hooks.sh.
    eval "$(devbox global shellenv --init-hook)" >/dev/null 2>&1 || true
}

setup_rust() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

setup_ghostty() {
    ln -fsv ~/dotfiles/ghostty/ $XDG_CONFIG_HOME/ghostty
}

setup_all() {
    setup_zsh
    setup_neovim
    setup_tmux
    setup_git
    setup_nix
    setup_devbox
    setup_ghostty
    # setup_rust  # opt-in; run `init.sh setup-rust` explicitly
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
        setup-all)     setup_all ;;
        setup-zsh)     setup_zsh ;;
        setup-neovim)  setup_neovim ;;
        setup-tmux)    setup_tmux ;;
        setup-git)     setup_git ;;
        setup-nix)     setup_nix ;;
        setup-devbox)  setup_devbox ;;
        setup-ghostty) setup_ghostty ;;
        setup-rust)    setup_rust ;;
        -h|--help|help)
            usage
            ;;
        *)
            echo "Unknown subcommand: $1" >&2
            echo >&2
            usage >&2
            exit 1
            ;;
    esac
}

main "$@"
