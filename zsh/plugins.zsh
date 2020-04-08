source ~/.zplug/init.zsh
# zplug plugins
zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

if [ -e "${HOME}/.zplug" ]; then
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
else
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

# zplug load --verbose
zplug load
