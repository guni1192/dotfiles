dir = $HOME/.zsh
if [ -e $dir ]; then
    cd $HOME/.zsh
else
    mkdir $HOME/.zsh && cd $HOME/.zsh
fi

git clone https://github.com/milkbikis/powerline-shell.git

cd powerline-shell
cp config.py.dit config.py

./install.py

cat $HOME/dotfiles/.zsh_pl >> $HOME/dotfiles.zshrc
