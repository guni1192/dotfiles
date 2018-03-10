"行番号の表示"
"set number
"tabはスペースつ分
set tabstop=4
set softtabstop=4
"tabで半角スペースで挿入する"
set expandtab
"Vimが自動で生成するtabをスペース4つ分にする"
set shiftwidth=4
"改行時、自動でインデント"
set smartindent
"オートインデントをオン
set autoindent
"空白文字の可視化"
set list
"ファイルの保存をしていなくても別のファイルを開けるようにする"
set hidden
set history=50
"文字のないところにカーソル移動できるようにする"
set virtualedit=block
"hjklの折り返し設定
set whichwrap=b,s,h,l,<,>,[,]
"バックスペースを制限無しにする"
set backspace=indent,eol,start
set wildmenu
set clipboard=unnamed,autoselect
"単語補完の入力候補の最大数"
set pumheight=10
set showmode
set wildmode=list:full
set encoding=utf-8

"Help Language
set helplang=ja,en

set cursorline
set mouse=a

inoremap jj <ESC>`^

" terminal emulator
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

