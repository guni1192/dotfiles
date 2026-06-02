#!/bin/bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
CONFIG_LOCAL="$DOTFILES_DIR/git/config.local"

if [[ -f "$CONFIG_LOCAL" ]]; then
    echo "$CONFIG_LOCAL already exists. Edit it directly or remove it first." >&2
    exit 0
fi

case "$(uname -s)" in
    Darwin) program="/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ;;
    Linux)  program="/opt/1Password/op-ssh-sign" ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac

read -rp "Git user name: " name
read -rp "Git user email: " email

signingkey=""
if command -v op >/dev/null 2>&1; then
    echo "Fetching SSH keys from 1Password..."
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
    exit 1
fi

{
    echo "# User-specific Git configuration"
    echo "# This file is not tracked in version control"
    echo ""
    echo "[user]"
    echo "    name = $name"
    echo "    email = $email"
    echo "    signingkey = $signingkey"
    echo ""
    echo "[gpg \"ssh\"]"
    echo "    program = $program"
} > "$CONFIG_LOCAL"

echo "Wrote $CONFIG_LOCAL"
