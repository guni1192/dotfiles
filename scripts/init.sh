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

require_aqua_sha256_tool() {
    case "$(uname -s)" in
        Linux)
            if ! command -v sha256sum >/dev/null 2>&1; then
                echo "aqua: sha256sum is required to verify the release archive and was not found" >&2
                exit 1
            fi
            ;;
        Darwin)
            if ! command -v shasum >/dev/null 2>&1; then
                echo "aqua: shasum is required to verify the release archive and was not found" >&2
                exit 1
            fi
            ;;
        *)
            echo "aqua: unsupported OS $(uname -s)" >&2
            exit 1
            ;;
    esac
}

sha256_file() {
    local file=$1
    local sum
    case "$(uname -s)" in
        Linux)
            sum=$(sha256sum -- "$file")
            ;;
        Darwin)
            sum=$(shasum -a 256 -- "$file")
            ;;
        *)
            echo "aqua: unsupported OS $(uname -s)" >&2
            exit 1
            ;;
    esac
    if [[ ! "$sum" =~ ^[0-9a-f]{64}[[:space:]] ]]; then
        echo "aqua: sha256 tool did not return a hash for $(basename "$file")" >&2
        exit 1
    fi
    printf '%s\n' "${sum%% *}"
}

check_aqua_sha256() {
    local file=$1
    local expected=$2
    local actual
    actual=$(sha256_file "$file")
    if [[ "$actual" != "$expected" ]]; then
        echo "aqua: sha256 mismatch for $(basename "$file")" >&2
        echo "aqua: expected ${expected}" >&2
        echo "aqua: actual   ${actual}" >&2
        exit 1
    fi
}

install_aqua_release() {
    # aqua v2.65.2 GitHub Release tarballs. These sha256 values are pinned in
    # this repo. Check them before extracting. Do not download aqua-installer,
    # and do not trust a checksums file fetched at runtime.
    # Bump this version and all four hashes together.
    local aqua_version=v2.65.2
    local os arch key expected asset tmp bindir
    case "$(uname -s)" in
        Linux) os=linux ;;
        Darwin) os=darwin ;;
        *)
            echo "aqua: unsupported OS $(uname -s)" >&2
            exit 1
            ;;
    esac
    case "$(uname -m)" in
        x86_64) arch=amd64 ;;
        arm64|aarch64) arch=arm64 ;;
        *)
            echo "aqua: unsupported architecture $(uname -m)" >&2
            exit 1
            ;;
    esac
    key="${os}/${arch}"
    case "$key" in
        darwin/amd64) expected=6552dc8cd3b4e51f781b4341cc3bb396028755080c6927f5a6d20b8ada85d4d1 ;;
        darwin/arm64) expected=74096ac247be24ec3340e134b9ecdae37465009d7bd1acca934a14a5beeb3314 ;;
        linux/amd64) expected=971abaccd16d0521fdb8e45990dba2aea17587f476aa075b621aeb972f52a61f ;;
        linux/arm64) expected=7abd3d2c27efad797c3284ab1ff21875b143daba28aecb2088917115b7f9cc81 ;;
        *)
            echo "aqua: no pinned sha256 for ${key}" >&2
            exit 1
            ;;
    esac
    if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
        echo "aqua: pinned sha256 for ${key} is not 64 hex characters" >&2
        exit 1
    fi
    require_aqua_sha256_tool
    asset="aqua_${os}_${arch}.tar.gz"
    bindir="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin"
    tmp=$(mktemp -d)
    (
        set -euo pipefail
        trap 'rm -rf "$tmp"' EXIT
        curl -fsSL -o "$tmp/$asset" \
            "https://github.com/aquaproj/aqua/releases/download/${aqua_version}/${asset}"
        check_aqua_sha256 "$tmp/$asset" "$expected"
        mkdir -p "$tmp/extract"
        tar -xzf "$tmp/$asset" -C "$tmp/extract" aqua
        if [[ ! -f "$tmp/extract/aqua" || -L "$tmp/extract/aqua" ]]; then
            echo "aqua: release archive did not contain a regular aqua binary" >&2
            exit 1
        fi
        mkdir -p "$bindir"
        rm -f "$bindir/aqua"
        cp "$tmp/extract/aqua" "$bindir/aqua"
        chmod 755 "$bindir/aqua"
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

remove_retired_user_skill_links() {
    # Project skills live in .cursor/skills. An earlier setup-cursor linked
    # ~/dotfiles/cursor/skills/<name> into ~/.cursor/skills. Drop those links
    # so the same skill is not also installed for every project.
    local dest="$HOME/.cursor/skills"
    local src_root="$HOME/dotfiles/cursor/skills"
    local link target
    [[ -d "$dest" ]] || return 0
    for link in "$dest"/*; do
        [[ -L "$link" ]] || continue
        target=$(readlink "$link")
        case "$target" in
            "$src_root"/*)
                rm -f "$link"
                ;;
        esac
    done
}

setup_cursor() {
    mkdir -p "$XDG_CONFIG_HOME/cursor" "$HOME/.cursor"
    create_symlink ~/dotfiles/cursor/permissions.json "$XDG_CONFIG_HOME/cursor/permissions.json"
    create_symlink ~/dotfiles/cursor/cli-config.json "$XDG_CONFIG_HOME/cursor/cli-config.json" replace
    create_symlink ~/dotfiles/cursor/hooks.json "$HOME/.cursor/hooks.json"
    create_symlink ~/dotfiles/cursor/hooks "$HOME/.cursor/hooks"
    remove_retired_user_skill_links
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
  setup-cursor    Symlink Cursor permissions and hooks.

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
