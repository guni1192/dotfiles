case ${OSTYPE} in
    darwin*)
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls --color'
        ;;
esac

alias la='ls -a'
alias ll='ls -al'

alias grep='grep --color'
alias df='df -h'

alias tmux='tmux -2'

# cd && ls
setopt auto_cd
function chpwd() { ls }

alias xr='xrdb ~/.Xresources'

# Ruby
alias be='bundle exec'

# gitignore
function gi(){
  curl -L -s https://www.gitignore.io/api/$@;
}

# ghq
alias repos='ghq list -p | fzf'
alias repo='cd $(repos)'

alias rbs="RUST_BACKTRACE=1"
alias rbf="RUST_BACKTRACE=full"

# jq less
alias jql='jq -C . | less -R'

alias az='docker run --rm -it -v ${HOME}/.kube/:/root/.kube/ -v ${HOME}/.azure/:/root/.azure/ -v ${HOME}/.ssh:/root/.ssh mcr.microsoft.com/azure-cli az'

alias gcpctx="
  gcloud config configurations list \
    | awk '{ print \$1,\$3,\$4 }' \
    | column -t \
    | fzf --header-lines=1 \
    | awk '{ print \$1 }' \
    | xargs -r gcloud config configurations activate
"
