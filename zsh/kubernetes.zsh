alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get service'
alias kgi='kubectl get ingress'

if command -v kubectl > /dev/null 2>&1; then
    source <(kubectl completion zsh)
    compdef __start_kubectl k
fi
