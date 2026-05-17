# Activate the devbox global profile so nix-managed tools (kubectl, helm,
# neovim, ...) are on PATH for interactive shells.
#
# `--init-hook` also evaluates the init_hook defined in devbox.json; entries
# there are guarded (`command -v ... ||`) so they are cheap on subsequent
# shell starts.
if command -v devbox >/dev/null 2>&1; then
    eval "$(devbox global shellenv --init-hook)"
fi
