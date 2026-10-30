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

    ZINIT_REV=cb4968123979cf073384e93aa8066d8fd450580f
    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    if [[ ! -d "$ZINIT_HOME/.git" ]]; then
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi
    if ! git -C "$ZINIT_HOME" cat-file -e "${ZINIT_REV}^{commit}" 2>/dev/null; then
        git -C "$ZINIT_HOME" fetch origin "$ZINIT_REV"
    fi
    git -C "$ZINIT_HOME" checkout --detach "$ZINIT_REV"
}

setup_neovim() {
    create_symlink ~/dotfiles/nvim $XDG_CONFIG_HOME/nvim
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

install_aqua_release() {
    # aqua-renovate-config installer-script matches the raw URL (aqua-installer)
    # and `aqua-installer -v` (aqua). The script is downloaded, then executed.
    # It is not piped into a shell. aqua-installer v4.1.1 checks the bootstrap
    # tarball checksum, then `update-aqua` installs the -v version.
    local tmp
    tmp=$(mktemp -d)
    (
        set -euo pipefail
        trap 'rm -rf "$tmp"' EXIT
        curl -fsSL -o "$tmp/aqua-installer" \
            "https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.1.1/aqua-installer"
        chmod +x "$tmp/aqua-installer"
        (
            cd "$tmp"
            ./aqua-installer -v v2.65.2
        )
    )
}

setup_aqua() {
    # Installs CLI tools from aquaproj-aqua/aqua.yaml.
    local aqua_bin_dir="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin"
    export PATH="$aqua_bin_dir:$PATH"

    if command -v aqua >/dev/null 2>&1; then
        echo "aqua already installed: $(aqua -v)"
    else
        echo "Installing aqua..."
        install_aqua_release
    fi

    create_symlink ~/dotfiles/aquaproj-aqua/ "$XDG_CONFIG_HOME/aquaproj-aqua"

    export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"
    # -a installs packages from AQUA_GLOBAL_CONFIG (ignored by default).
    # claude.yaml is a separate file and is not installed here.
    aqua install -a
    setup_rust_toolchain
    setup_claude
}

setup_rust_toolchain() {
    # The aqua package is only the rustup manager. Install the stable
    # toolchain with that binary (same result as rustup-init -y
    # --default-toolchain stable). Do not use https://sh.rustup.rs.
    if ! command -v rustup-init >/dev/null 2>&1; then
        echo "rustup-init is not on PATH; the stable toolchain was not installed." >&2
        return 1
    fi
    rustup-init -y --default-toolchain stable
}

claude_is_aqua_proxy() {
    local bin target
    bin=$(command -v claude 2>/dev/null || true)
    [[ -n "$bin" && -L "$bin" ]] || return 1
    target=$(readlink "$bin")
    [[ "$(basename "$target")" == "aqua-proxy" ]]
}

claude_runs() {
    local bin
    bin=$(command -v claude 2>/dev/null || true)
    [[ -n "$bin" && -x "$bin" ]] || return 1
    if claude_is_aqua_proxy; then
        return 1
    fi
    "$bin" --version >/dev/null 2>&1
}

merge_claude_settings() {
    local dest="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    if [[ -L "$dest" || ! -e "$dest" ]]; then
        create_symlink ~/dotfiles/claude/settings.json "$dest"
        return 0
    fi
    if [[ ! -f "$dest" ]]; then
        echo "claude settings: skipped ($dest is not a regular file)."
        return 0
    fi
    if ! command -v jq >/dev/null 2>&1; then
        echo "claude settings: skipped (jq is not available, so autoUpdatesChannel was not added to $dest)."
        return 0
    fi
    if ! jq -e 'type == "object"' "$dest" >/dev/null 2>&1; then
        echo "claude settings: skipped ($dest is not a JSON object, so autoUpdatesChannel was not added)."
        return 0
    fi
    if jq -e 'has("autoUpdatesChannel")' "$dest" >/dev/null 2>&1; then
        echo "claude settings: autoUpdatesChannel is already set; left $dest unchanged."
        return 0
    fi
    local tmp
    tmp=$(mktemp)
    if jq '.autoUpdatesChannel = "stable"' "$dest" > "$tmp"; then
        mv "$tmp" "$dest"
        echo "claude settings: added autoUpdatesChannel=stable to $dest."
    else
        rm -f "$tmp"
        echo "claude settings: skipped (could not add autoUpdatesChannel to $dest)."
    fi
}

install_claude_once() {
    local cfg=~/dotfiles/aquaproj-aqua/claude.yaml
    local dest="${HOME}/.local/bin/claude"
    local real aqua_shim
    echo "Installing claude-code once via aqua..."
    aqua -c "$cfg" install
    real=$(aqua -c "$cfg" which claude)
    if [[ -z "$real" || ! -x "$real" ]]; then
        echo "claude: aqua did not produce an executable." >&2
        return 1
    fi
    if [[ -L "$real" ]] && [[ "$(basename "$(readlink "$real")")" == "aqua-proxy" ]]; then
        echo "claude: aqua which returned the proxy, not the installed binary." >&2
        return 1
    fi
    mkdir -p "${HOME}/.local/bin"
    install -m 755 "$real" "$dest"
    aqua_shim="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin/claude"
    if [[ -L "$aqua_shim" ]] && [[ "$(basename "$(readlink "$aqua_shim")")" == "aqua-proxy" ]]; then
        rm -f "$aqua_shim"
    fi
    "$dest" --version
}

setup_claude() {
    # Official install is `curl | bash` or Homebrew. Neither is used.
    # aqua verifies the GitHub release once, then the binary is copied out of
    # the aqua proxy so later `aqua install -a` does not reset auto-updates.
    merge_claude_settings
    if claude_runs; then
        echo "claude already installed: $(claude --version 2>/dev/null || true)"
        return 0
    fi
    install_claude_once
}

setup_ghostty() {
    create_symlink ~/dotfiles/ghostty/ $XDG_CONFIG_HOME/ghostty
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
    setup_herdr
    setup_git
    setup_ghostty
    setup_cursor
}

remove_removed_tool_symlinks() {
    # setup_pnpm, setup_tmux, and setup_bin used to create these. The repo
    # files are gone, so an old symlink is dangling. Leave a real file alone.
    local path
    for path in \
        "$XDG_CONFIG_HOME/pnpm/rc" \
        "$XDG_CONFIG_HOME/tmux" \
        "$HOME/.local/bin/nvim-tmux"
    do
        if [[ -L "$path" ]]; then
            rm -f "$path"
        fi
    done
}

setup_all_with_aqua() {
    remove_removed_tool_symlinks
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
  setup-herdr     Symlink herdr config.toml (not the whole directory).
  setup-git       Symlink git config.
  setup-aqua      Install aqua and apply aquaproj-aqua/aqua.yaml.
  setup-claude    Symlink Claude settings. Install claude once if missing.
  setup-ghostty   Symlink ghostty config.
  setup-cursor    Symlink Cursor IDE permission configs and hooks.

Rustup is an aqua package (rust-lang/rustup). setup-aqua then runs
that rustup-init with -y --default-toolchain stable.
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
