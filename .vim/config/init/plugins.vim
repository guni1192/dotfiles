if has('vim_starting')
    set rtp+=~/.vim/plugged/vim-plug
    if !isdirectory(expand('~/.vim/plugged/vim-plug'))
        echo 'install vim-plug...'
        call system('mkdir -p ~/.vim/plugged/vim-plug')
        call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
    end
endif

call plug#begin('~/.vim/plugged')
    Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
    Plug 'Shougo/denite.nvim'
    Plug 'flazz/vim-colorschemes'
    Plug 'vim-jp/vimdoc-ja'
    Plug 'vim-airline/vim-airline'
    Plug 'cespare/vim-toml'
call plug#end()

