#!/bin/sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
setxkbmap -option ctrl:nocaps
xsetroot -cursor_name left_ptr
# if [ -s ~/.Xmodmap ]; then
    # xmodmap ~/.Xmodmap
# fi
# exec xmonad
# exec gnome-session --session xmonad-gnome-nopanel "$@"
# export DE="xfce"
