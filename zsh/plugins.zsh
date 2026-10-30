ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Commits are pinned. `zinit light` does not pull on startup.
# `zinit update` checks out `ver` again.

ZSH_256COLOR_REV=559fee48bb74b75cec8b9887f8f3e046f01d5d8f
zinit ice ver"$ZSH_256COLOR_REV"
zinit light chrissicool/zsh-256color

ZSH_AUTOSUGGESTIONS_REV=85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5
zinit ice ver"$ZSH_AUTOSUGGESTIONS_REV"
zinit light zsh-users/zsh-autosuggestions

ZSH_SYNTAX_HIGHLIGHTING_REV=e6683f20e5c38d3e5447f45845d04ddda75d0f23
zinit ice ver"$ZSH_SYNTAX_HIGHLIGHTING_REV"
zinit light zsh-users/zsh-syntax-highlighting

ZSH_COMPLETIONS_REV=989b23277ab33e8d5e82df6aed936e846db9d8b8
zinit ice ver"$ZSH_COMPLETIONS_REV"
zinit light zsh-users/zsh-completions
