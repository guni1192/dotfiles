if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/.zshrc ~/.zshrc
    ln -s ~/dotfiles/.xmonad ~/.xmonad
    mkdir ~/.emacs.d
    git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

