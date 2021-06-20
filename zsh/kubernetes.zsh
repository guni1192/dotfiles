alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get service'
alias kgi='kubectl get ingress'

source <(kubectl completion zsh)
complete -F __start_kubectl k
