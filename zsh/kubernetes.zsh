alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get service'
alias kgi='kubectl get ingress'


if kubectl 2> /dev/null; then
    source <(kubectl completion zsh)
    complete -F __start_kubectl k
fi
