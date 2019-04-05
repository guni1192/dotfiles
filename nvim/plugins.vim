if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
" General Plugins {{{
Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
Plug 'vim-jp/vimdoc-ja'
Plug 'Shougo/denite.nvim'
Plug 'cohama/lexima.vim'
" }}}

" ColorScheme {{{
Plug 'flazz/vim-colorschemes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sjl/badwolf'
" }}}

" Syntax Highlight {{{
Plug 'cespare/vim-toml'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'tmux-plugins/vim-tmux'
Plug 'chr4/nginx.vim'
Plug 'sngn/vim-i3blocks-syntax'
Plug 'justinmk/vim-syntax-extra'
" }}}

" Golang {{{
" }}}

" Rust {{{
"}}}

" LSP {{{
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'natebosch/vim-lsc'
" }}}

call plug#end()
