alias tmux='tmux -2'
# alias ls='ls --color'
# alias la='ls -a --color'
# alias ll='ls -al'
alias ls="exa -s=type"
alias la="exa -a"
alias ll="exa -alg --git"
alias tree="exa -T"

# alias cat='ccat'
alias grep='grep --color'
alias df='df -h'

# cd && ls
setopt auto_cd
function chpwd() { ls }

# Neovim
alias ni='nvim $NVIM/init.vim'
alias nd='nvim $NVIM/dein.toml'
alias ndl='nvim $NVIM/dein_lazy.toml'

# shell
alias ez='exec zsh'

alias xr='xrdb ~/.Xresources'

# Emacs Settiing
alias emacs='emacs -nw'
alias e='emacs'
alias ei='e ~/.emacs.d/init.el'

# Ruby
alias be='bundle exec'

# Python
alias prun='pipenv run'
alias ve='source venv/bin/activate'

# gitignore
function gi(){
  curl -L -s https://www.gitignore.io/api/$@;
}

# ghq
alias repos='ghq list -p | fzf'
alias repo='cd $(repos)'

# omit
alias o='$(omit | fzf)'
function omitation() {
  $(omit | fzf)
}
zle -N omitation
bindkey '^k' omitation

# alias git='hub'
alias rbs="RUST_BACKTRACE=1"
alias cb='cargo build'
alias cr='cargo run'

# Man for jp
alias jan='MANPATH=/usr/share/man/ja_JP.UTF-8/ man'
