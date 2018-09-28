# alias tmux='tmux -2'
# alias ls='ls --color'
# alias la='ls -a --color'
# alias ll='ls -al'
alias ls="exa -s=type"
alias la="exa -a"
alias ll="exa -al --git"
alias tree="exa -T"

# alias cat='ccat'
alias grep='grep --color'
alias df='df -h'

# cd && ls
setopt auto_cd
function chpwd() { ls }

# alias vim='nvim'
alias vi='nvim'
alias ni='nvim $NVIM/init.vim'
alias nd='nvim $NVIM/dein.toml'
alias ndl='nvim $NVIM/dein_lazy.toml'
alias ez='exec zsh'
alias ve='source venv/bin/activate'
alias xr='xrdb ~/.Xresources'

# Emacs Settiing
alias emacs='emacs -nw'
alias e='emacs'
alias ei='e ~/.emacs.d/init.el'

# Ruby Develop tool
alias be='bundle exec'

function gi(){
  curl -L -s https://www.gitignore.io/api/$@;
}

alias repos='ghq list -p | peco'
alias repo='cd $(repos)'

alias rb='RUST_BACKTRACE=1'
alias cb='cargo build'
alias cr='cargo run'
