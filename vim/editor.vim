set number
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smartindent
set autoindent
set list
set hidden
set history=50
set virtualedit=block
"hjklの折り返し設定
set whichwrap=b,s,h,l,<,>,[,]
"バックスペースを制限無しにする"
set backspace=indent,eol,start
set wildmenu
set clipboard=unnamed
"単語補完の入力候補の最大数"
set pumheight=10
set showmode
set wildmode=list:full
set encoding=utf-8
"Help Language
set helplang=ja,en
set cursorline

inoremap jj <ESC>`^

" terminal emulator
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

"折りたたみしない
set foldmethod=syntax
set foldlevel=100
