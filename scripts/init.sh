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
    local replace_existing=${3:-}
    if [[ -L "$link_name" ]]; then
        rm "$link_name"
        ln -sv "$source_file" "$link_name"
    elif [[ -f "$link_name" && -n "$replace_existing" ]]; then
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

setup_herdr() {
    # Symlink just config.toml — Herdr also stores logs, sockets, and
    # session.json under $XDG_CONFIG_HOME/herdr, which must stay local.
    mkdir -p "$XDG_CONFIG_HOME/herdr"
    create_symlink ~/dotfiles/herdr/config.toml "$XDG_CONFIG_HOME/herdr/config.toml"
}

setup_git() {
    create_symlink ~/dotfiles/git/ $XDG_CONFIG_HOME/git
}

# renovate: datasource=github-releases depName=aquaproj/aqua
AQUA_VERSION=v2.65.2

install_aqua_release() {
    local aqua_bin_dir=$1
    local os arch asset sums tmp expected actual
    case "$(uname -s)" in
        Darwin) os=darwin ;;
        Linux) os=linux ;;
        *)
            echo "Unsupported OS: $(uname -s)" >&2
            exit 1
            ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64) arch=amd64 ;;
        arm64|aarch64) arch=arm64 ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            exit 1
            ;;
    esac
    asset="aqua_${os}_${arch}.tar.gz"
    sums="aqua_${AQUA_VERSION#v}_checksums.txt"
    tmp=$(mktemp -d)
    (
        set -euo pipefail
        trap 'rm -rf "$tmp"' EXIT
        curl -fsSL -o "$tmp/$asset" \
            "https://github.com/aquaproj/aqua/releases/download/${AQUA_VERSION}/${asset}"
        curl -fsSL -o "$tmp/$sums" \
            "https://github.com/aquaproj/aqua/releases/download/${AQUA_VERSION}/${sums}"
        expected=$(awk -v f="$asset" '$2 == f { print $1 }' "$tmp/$sums")
        if [[ -z "$expected" ]]; then
            echo "No checksum for ${asset} in ${sums}" >&2
            exit 1
        fi
        if command -v sha256sum >/dev/null 2>&1; then
            actual=$(sha256sum "$tmp/$asset" | awk '{ print $1 }')
        elif command -v shasum >/dev/null 2>&1; then
            actual=$(shasum -a 256 "$tmp/$asset" | awk '{ print $1 }')
        else
            echo "sha256sum or shasum is required to install aqua" >&2
            exit 1
        fi
        if [[ "$actual" != "$expected" ]]; then
            echo "aqua checksum mismatch for ${asset}" >&2
            exit 1
        fi
        tar -xzf "$tmp/$asset" -C "$tmp" aqua
        mkdir -p "$aqua_bin_dir"
        install -m 755 "$tmp/aqua" "$aqua_bin_dir/aqua"
    )
}

setup_aqua() {
    # Installs CLI tools from aquaproj-aqua/aqua.yaml.
    local aqua_bin_dir="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin"
    export PATH="$aqua_bin_dir:$PATH"

    if command -v aqua >/dev/null 2>&1; then
        echo "aqua already installed: $(aqua -v)"
    else
        echo "Installing aqua ${AQUA_VERSION}..."
        install_aqua_release "$aqua_bin_dir"
    fi

    create_symlink ~/dotfiles/aquaproj-aqua/ "$XDG_CONFIG_HOME/aquaproj-aqua"

    export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"
    # -a installs packages from AQUA_GLOBAL_CONFIG (ignored by default).
    # claude.yaml is a separate file and is not installed here.
    aqua install -a
    setup_claude
}

setup_claude() {
    # Official install is `curl | bash` or Homebrew. Neither is used.
    # aqua installs the GitHub release once. Later versions come from Claude's
    # updater on the stable channel (claude/settings.json).
    mkdir -p "$HOME/.claude"
    create_symlink ~/dotfiles/claude/settings.json "$HOME/.claude/settings.json"
    if command -v claude >/dev/null 2>&1; then
        echo "claude already installed: $(claude --version 2>/dev/null || true)"
        return
    fi
    echo "Installing claude-code once via aqua..."
    aqua -c ~/dotfiles/aquaproj-aqua/claude.yaml install
}

setup_ghostty() {
    create_symlink ~/dotfiles/ghostty/ $XDG_CONFIG_HOME/ghostty
}

setup_pnpm() {
    # Symlink just `rc` rather than the whole directory — pnpm also stores
    # state (store-v3, etc.) under $XDG_CONFIG_HOME/pnpm on some setups.
    mkdir -p "$XDG_CONFIG_HOME/pnpm"
    create_symlink ~/dotfiles/pnpm/rc "$XDG_CONFIG_HOME/pnpm/rc"
}

setup_bin() {
    mkdir -p "$HOME/.local/bin"
    create_symlink ~/dotfiles/bin/nvim-tmux "$HOME/.local/bin/nvim-tmux"
}

setup_cursor() {
    mkdir -p "$XDG_CONFIG_HOME/cursor" "$HOME/.cursor"
    create_symlink ~/dotfiles/cursor/permissions.json "$XDG_CONFIG_HOME/cursor/permissions.json"
    create_symlink ~/dotfiles/cursor/cli-config.json "$XDG_CONFIG_HOME/cursor/cli-config.json" replace
    create_symlink ~/dotfiles/cursor/hooks.json "$HOME/.cursor/hooks.json"
    create_symlink ~/dotfiles/cursor/hooks "$HOME/.cursor/hooks"
}

setup_dotfiles() {
    setup_zsh
    setup_neovim
    setup_tmux
    setup_herdr
    setup_git
    setup_ghostty
    setup_pnpm
    setup_bin
    setup_cursor
}

setup_all_with_aqua() {
    setup_dotfiles
    setup_aqua
}

setup_all() {
    setup_all_with_aqua
}

usage() {
    cat <<'EOF'
Usage: scripts/init.sh <subcommand>

Full initial setup (leading -- is optional):
  setup-all               Dotfiles + aqua (CLI tools).
  setup-all-with-aqua     Same as setup-all.

Individual steps:
  setup-zsh       Symlink zshenv + zsh config and clone zinit.
  setup-neovim    Symlink neovim config.
  setup-tmux      Symlink tmux config.
  setup-herdr     Symlink herdr config.toml (not the whole directory).
  setup-git       Symlink git config.
  setup-aqua      Install aqua and apply aquaproj-aqua/aqua.yaml.
  setup-claude    Symlink Claude settings. Install claude once if missing.
  setup-ghostty   Symlink ghostty config.
  setup-pnpm      Symlink pnpm global rc config.
  setup-bin       Symlink nvim-tmux into ~/.local/bin/.
  setup-cursor    Symlink Cursor IDE/CLI permission configs.

Rustup is an aqua package (rust-lang/rustup) and is installed by setup-aqua.
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

    # Allow `--setup-foo` as well as `setup-foo`.
    local cmd="${1#--}"

    # setup-foo → setup_foo, dispatched only if defined as a function. This
    # keeps the subcommand list and the function names in lockstep — no
    # separate case arms to drift from the usage text.
    local fn="${cmd//-/_}"
    if [[ "$cmd" == setup-* ]] && declare -F "$fn" >/dev/null; then
        "$fn"
    else
        echo "Unknown subcommand: $1" >&2
        echo >&2
        usage >&2
        exit 1
    fi
}

main "$@"
