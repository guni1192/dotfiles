# Activate the devbox global profile so nix-managed tools (kubectl, helm,
# neovim, ...) are on PATH for interactive shells.
#
# Plain `shellenv` only exports env vars and updates PATH — it has no file
# dependencies. We deliberately do NOT pass `--init-hook` here: that flag
# sources `.devbox/gen/scripts/.hooks.sh`, which is fragile across container
# rebuilds and host/container layout drift. The init_hook itself runs once
# from `scripts/init.sh setup-devbox`.
if command -v devbox >/dev/null 2>&1; then
    eval "$(devbox global shellenv 2>/dev/null)"
fi
