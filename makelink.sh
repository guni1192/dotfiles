# macの場合
if [ "$(uname)" == 'Darwin' ]; then
 ppnp   ln -s ~/dotfiles/.zshrc_mac ~/zshrc
# linuxの場合
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/.zshrc_arch ~/.zshrc
    ln -s ~/dotfiles/.xmonad ~/.xmonad
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

mkdir ~/.emacs.d
<<<<<<< HEAD
git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get
ln -s ~/dotfiles/.init.el ~/.emacs.d/init.el
=======
git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
ln -s ~/dotfiles/.emacs.d ~/.emacs.d
ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
>>>>>>> 5366806bf7fe4f918dc8a44ce4f4a0fcb439149d
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
