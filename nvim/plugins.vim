" if has('vim_starting')
"   set rtp+=~/.vim/plugged/vim-plug
"   if !isdirectory(expand('~/.vim/plugged/vim-plug'))
"     echo 'install vim-plug...'
"     call system('mkdir -p ~/.vim/plugged/vim-plug')
"     call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
"   end
" endif

call plug#begin(stdpath('data') . '/plugged')

" General Plugins
Plug 'junegunn/vim-plug', {'dir': stdpath('data') . '/plugged/vim-plug/autoload'}
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
Plug 'vim-jp/vimdoc-ja'
Plug 'cohama/lexima.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/vim-clang-format'

" ColorScheme
Plug 'flazz/vim-colorschemes'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax Highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'cespare/vim-toml'
Plug 'tmux-plugins/vim-tmux'
Plug 'chr4/nginx.vim'
Plug 'justinmk/vim-syntax-extra'

" i3wm
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'sngn/vim-i3blocks-syntax'

" HCL
Plug 'b4b4r07/vim-hcl'
Plug 'hashivim/vim-terraform'

" Go
Plug 'mattn/vim-goimports'

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()
