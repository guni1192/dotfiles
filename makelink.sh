# macの場合
if [ "$(uname)" == 'Darwin' ]; then
    ln -s ~/dotfiles/.zshrc_mac ~/zshrc
# linuxの場合
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/.zshrc_arch ~/.zshrc
    ln -s ~/dotfiles/.xmonad ~/.xmonad
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

ln -s ~/dotfiles/.emacs.d ~/.emacs.d
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
