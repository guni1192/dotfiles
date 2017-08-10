if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    ln -s ~/dotfiles/.Xresources ~/.Xresources
    # Zsh
    ln -s ~/dotfiles/.zsh ~/.zsh
    ln -s ~/.zsh/.zshrc ~/.zshrc
    ln -s ~/.zsh/.zshenv ~/.zshenv
    # Xmonad
    ln -s ~/dotfiles/.xmonad ~/.xmonad
    if [ ! -e $HOME/.config ]; then
      mkdir $HOME/.config
    fi
    # i3 Window Manager
    ln -s ~/dotfiles/i3 ~/.config/i3
    # polybar
    ln -s ~/dotfiles/polybar ~/.config/polybar
    # ranger
    ln -s ~/dotfiles/ranger ~/.config/ranger
    # NeoVim
    ln -s ~/dotfiles/nvim ~/.config/nvim
    # ideavim
    ln -s ~/dotfiles/.ideavimrc ~/.ideavimrc
    # Emacs
    if [ ! -e $HOME/.emacs.d ]; then
      mkdir ~/.emacs.d
    fi
    git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    # tmux
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
    # stalonetray
    ln -s ~/dotfiles/.stalonetrayrc ~/.stalonetrayrc
    # asdf-vm
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
elif [ "$(expr substr $(uname -s) 1 5)" == 'Darwin' ]; then
    # Zsh
    ln -s ~/dotfiles/.zsh ~/.zsh
    ln -s ~/.zsh/.zshrc ~/.zshrc
    ln -s ~/.zsh/.zshenv ~/.zshenv
    # ranger
    ln -s ~/dotfiles/ranger ~/.config/ranger
    # NeoVim
    ln -s ~/dotfiles/nvim ~/.config/nvim
    # ideavim
    ln -s ~/dotfiles/.ideavimrc ~/.ideavimrc
    # Emacs
    if [ ! -e $HOME/.emacs.d ]; then
      mkdir ~/.emacs.d
    fi
    git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    # tmux
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

