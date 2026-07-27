#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
CONFIG_LOCAL="$DOTFILES_DIR/git/config.local"
CONFIG_WORK="$DOTFILES_DIR/git/config.work"

prompt_signingkey() {
    local label="$1"
    local signingkey=""

    if command -v op >/dev/null 2>&1; then
        echo "Fetching SSH keys from 1Password ($label)..."
        if keys_json=$(op item list --categories "SSH Key" --format=json 2>/dev/null) && [[ -n "$keys_json" && "$keys_json" != "[]" ]]; then
            mapfile -t ids   < <(printf '%s' "$keys_json" | jq -r '.[].id')
            mapfile -t names < <(printf '%s' "$keys_json" | jq -r '.[].title')
            for i in "${!ids[@]}"; do
                printf '  [%d] %s\n' "$((i+1))" "${names[$i]}"
            done
            read -rp "Select key number (empty to enter manually): " sel
            if [[ -n "$sel" && "$sel" =~ ^[0-9]+$ && "$sel" -ge 1 && "$sel" -le "${#ids[@]}" ]]; then
                signingkey=$(op item get "${ids[$((sel-1))]}" --fields "public key" --reveal 2>/dev/null \
                    | tr -d '"')
            fi
        else
            echo "(No SSH keys found in 1Password, or not signed in. Run \`op signin\` and retry, or paste the key manually.)"
        fi
    fi

    if [[ -z "$signingkey" ]]; then
        read -rp "SSH signing public key (e.g. 'ssh-ed25519 AAAA...'): " signingkey
    fi

    if [[ -z "$signingkey" ]]; then
        echo "Signing key is required for 1Password-based signing." >&2
        return 1
    fi

    printf '%s' "$signingkey"
}

case "$(uname -s)" in
    Darwin) program="/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ;;
    Linux)  program="/opt/1Password/op-ssh-sign" ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

if [[ -f "$CONFIG_LOCAL" ]]; then
    echo "$CONFIG_LOCAL already exists; skipping personal identity."
else
    read -rp "Personal Git user name: " name
    read -rp "Personal Git user email: " email
    signingkey=$(prompt_signingkey "personal")

    {
        echo "# Personal Git identity (default)."
        echo "# This file is not tracked in version control."
        echo ""
        echo "[user]"
        echo "    name = $name"
        echo "    email = $email"
        echo "    signingkey = $signingkey"
        echo ""
        echo "[gpg \"ssh\"]"
        echo "    program = $program"
        echo ""
        echo "# Optional: work identity under a specific checkout path."
        echo "# Create config.work (gitignored) and uncomment, adjusting gitdir:"
        echo "#"
        echo "# [includeIf \"gitdir:~/path/to/work/\"]"
        echo "#     path = ~/.config/git/config.work"
    } > "$CONFIG_LOCAL"

    echo "Wrote $CONFIG_LOCAL"
fi

read -rp "Set up work Git identity now? [y/N] " setup_work
if [[ ! "$setup_work" =~ ^[Yy]$ ]]; then
    exit 0
fi

if [[ -f "$CONFIG_WORK" ]]; then
    echo "$CONFIG_WORK already exists. Edit it directly or remove it first." >&2
    exit 0
fi

read -rp "Work Git user email: " work_email
work_signingkey=$(prompt_signingkey "work")
read -rp "Work checkout gitdir (e.g. ~/work/ or ~/.ghq/github.com/org/): " work_gitdir

if [[ -z "$work_gitdir" ]]; then
    echo "Work gitdir is required to wire includeIf." >&2
    exit 1
fi

# Normalize trailing slash for gitdir matching.
[[ "$work_gitdir" == */ ]] || work_gitdir="${work_gitdir}/"

{
    echo "# Work Git identity overrides."
    echo "# This file is not tracked in version control."
    echo ""
    echo "[user]"
    echo "    email = $work_email"
    echo "    signingkey = $work_signingkey"
} > "$CONFIG_WORK"

echo "Wrote $CONFIG_WORK"

if grep -q '^\[includeIf ' "$CONFIG_LOCAL" 2>/dev/null; then
    echo "config.local already has an includeIf; add the following manually if needed:"
    echo "  [includeIf \"gitdir:$work_gitdir\"]"
    echo "      path = ~/.config/git/config.work"
else
    {
        echo ""
        echo "[includeIf \"gitdir:$work_gitdir\"]"
        echo "    path = ~/.config/git/config.work"
    } >> "$CONFIG_LOCAL"
    echo "Appended includeIf for $work_gitdir to $CONFIG_LOCAL"
fi
