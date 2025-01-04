autoload -Uz compinit promptinit
compinit


# Completion

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

autoload predict-on

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

WORDCHARS="$WORDCHARS|:"

setopt AUTO_MENU
setopt AUTO_LIST
setopt AUTO_PARAM_KEYS
setopt AUTO_RESUME
unsetopt AUTO_CD

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt NO_PROMPTCR
unsetopt XTRACE
setopt INTERACTIVE_COMMENTS

bindkey -e

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

unsetopt AUTOREMOVESLASH

export HISTFILE=$XDG_DATA_HOME/zsh/history
export HISTSIZE=1000
export SAVEHIST=100000

function fzf-history-selection() {
    BUFFER=`history -n 1 | fzf`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection
