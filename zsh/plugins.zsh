if [ -e "${HOME}/.zplug" ]; then
    source ~/.zplug/init.zsh
    if ! zplug check --verbose; then
        echo; zplug install
    fi
else
    git clone https://github.com/zplug/zplug ~/.zplug
fi

# zplug plugins
zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

zplug load
