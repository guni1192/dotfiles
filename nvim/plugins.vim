if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
" Required Plugins {{{
Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
Plug 'vim-jp/vimdoc-ja'
Plug 'Shougo/denite.nvim'
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
Plug 'hdima/python-syntax'
Plug 'hail2u/vim-css3-syntax'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tmux-plugins/vim-tmux'
Plug 'slim-template/vim-slim'
Plug 'chr4/nginx.vim'
Plug 'aklt/plantuml-syntax'
Plug 'sngn/vim-i3blocks-syntax'
Plug 'justinmk/vim-syntax-extra'
"   ES6 Syntax
Plug 'othree/yajs.vim'
"   .vue Syntax
Plug 'posva/vim-vue'
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'
" }}}
Plug 'twitvim/twitvim'
" Snipett, Completion {{{
Plug 'Shougo/neosnippet-snippets'
Plug 'cohama/lexima.vim'
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'vim-ruby/vim-ruby'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-clang'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go'
Plug 'fishbullet/deoplete-ruby'
Plug 'Shougo/neosnippet'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'rust-lang/rust.vim'
" }}}
"Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
Plug 'fatih/vim-go'
Plug 'nsf/gocode', {'rtp': 'vim/'}
Plug 'nvie/vim-flake8'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()
