if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s ~/dotfiles/.Xdefaults ~/.Xdefaults
    ln -s ~/dotfiles/.zshrc ~/.zshrc
    ln -s ~/dotfiles/.zshrc_base ~/.zshrc_base
    ln -s ~/dotfiles/.zshrc_linux ~/.zshrc_os
    ln -s ~/dotfiles/.xmonad ~/.xmonad
    mkdir ~/.emacs.d
    git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
    # If use ThinkPad, .Xmodmap added
    # ln -s /home/guni/dotfiles/.Xmodmap /home/guni/.Xmodmap
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

