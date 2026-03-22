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

# gitignore
function gi(){
  curl -L -s https://www.gitignore.io/api/$@;
}

# ghq
alias repos='ghq list -p | fzf'
alias repo='cd $(repos)'

# jq less
alias jql='jq -C . | less -R'

# git worktree
alias gwt='cd $(git worktree list | fzf | awk "{ print \$1 }")'

alias gcpctx="
  gcloud config configurations list \
    | awk '{ print \$1,\$3,\$4 }' \
    | column -t \
    | fzf --header-lines=1 \
    | awk '{ print \$1 }' \
    | xargs -r gcloud config configurations activate
"
