# asdf-vm
# . $HOME/.asdf/asdf.sh
# . $HOME/.asdf/completions/asdf.bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export NVM_DIR="/home/guni/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:`yarn global bin`"

# export GOROOT=$HOME/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PATH=$PATH:$HOME/bin
