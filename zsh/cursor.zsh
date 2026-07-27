# Cursor CLI: use nvim-tmux as EDITOR/VISUAL only for agent sessions.
if command -v cursor-agent >/dev/null 2>&1; then
  agent() {
    EDITOR="$HOME/.local/bin/nvim-tmux" \
    VISUAL="$HOME/.local/bin/nvim-tmux" \
      cursor-agent "$@"
  }
fi
