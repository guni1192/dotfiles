# asdf-vm
# . $HOME/.asdf/asdf.sh
# . $HOME/.asdf/completions/asdf.bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR="/home/guni/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
