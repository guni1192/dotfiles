# Activate the devbox global profile for interactive shells.
# --init-hook intentionally omitted: it sources a generated .hooks.sh that's
# fragile across container rebuilds. stderr is silenced to drop devbox's
# spurious "environment may be out of date" warning.
if command -v devbox >/dev/null 2>&1; then
    eval "$(devbox global shellenv 2>/dev/null)"
fi
