if [ ! -e $HOME/.emacs.d/el-get/ ]; then
    rm -r ~/.emacs.d/el-get
fi

if [ ! -e $HOME/.config ]; then
    mkdir $HOME/.config
fi

git clone https://github.com/dimitri/el-get.git ~/.emacs.d/el-get/
git clone https://github.com/rupa/z.git ~/.zsh.d

if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    # Zsh
    ln -s ~/dotfiles/.zsh ~/.zsh
    ln -s ~/.zsh/.zshrc ~/.zshrc
    ln -s ~/.zsh/.zshenv ~/.zshenv
    # Xmonad
    ln -s ~/dotfiles/.xmonad ~/.xmonad
    # i3 Window Manager
    ln -s ~/dotfiles/i3 ~/.config/i3
    # polybar
    ln -s ~/dotfiles/polybar ~/.config/polybar
    # ranger
    ln -s ~/dotfiles/ranger ~/.config/ranger
    # Vim
    ln -s ~/dotfiles/.vimrc ~/.vimrc
    if [ ! -e $HOME/.vim ]; then
        mkdir $HOME/.vim.
    fi
    ln -s ~/dotfiles/.vim/config ~/.vim/config
    # NeoVim
    ln -s ~/dotfiles/nvim ~/.config/nvim
    # ideavim
    ln -s ~/dotfiles/.ideavimrc ~/.ideavimrc
    # Emacs
    if [ ! -e $HOME/.emacs.d ]; then
        mkdir ~/.emacs.d
    fi
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    # tmux
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
    # stalonetray
    ln -s ~/dotfiles/.stalonetrayrc ~/.stalonetrayrc

    read -p "Is this Display HiDPI?[y/n] " yn ;
    case $yn in
        [Yy]* ) {
            ln -s ~/dotfiles/.Xresources ~/.Xresources
        };;
    [Nn]* ) {
        ln -s ~/dotfiles/.Xresources ~/.Xresources
    };;
  esac

  read -p "Do you use X11?[y/n] " yn ;
  case $yn in
      [Yy]* ) {
          # Xmonad
          echo "Xmonad linking ..."
          ln -s ~/dotfiles/.xmonad ~/.xmonad
          if [ ! -e $HOME/.config ]; then
              mkdir $HOME/.config
          fi
          # i3 Window Manager
          echo "i3wm linking ..."
          ln -s ~/dotfiles/i3 ~/.config/i3

          # polybar
          echo "polybar linking ..."
          ln -s ~/dotfiles/polybar ~/.config/polybar
      };;
  esac

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
    ln -s ~/dotfiles/init.el ~/.emacs.d/init.el
    # tmux
    ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

