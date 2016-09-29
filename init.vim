"行番号の表示"
set number
"全角文字の幅を2に固定"
set ambiwidth=double
"tabはスペース4つ分"
set tabstop=4
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
"可視化した空白文字の表示形式"
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
"0から始まる数値を8進数として扱わないようにする"
set nrformats-=octal
"ファイルの保存をしていなくても別のファイルを開けるようにする"
set hidden
set history=50
"文字のないところにカーソル移動できるようにする"
set virtualedit=block
"hjklの折り返し設定"
set whichwrap=b,s,h,l,<,>,[,]
"バックスペースを制限無しにする"
set backspace=indent,eol,start
set wildmenu
"set clipboard+=unnamed,autoselect
"単語補完の入力候補の最大数"
set pumheight=10
set showmatch
set matchtime=1
set showmode
set wildmenu wildmode=list:full
set softtabstop=4
" ノーマルモードのキーバインド"
inoremap jj <ESC>
" NERDTreeをctrl+eで開く
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on
autocmd FileType c set cindent
autocmd FileType cpp set cindent

" トラックパッドでスクロールできるようにする
set mouse=a

"colorscheme{{{
syntax on
colorscheme solarized
highlight Normal ctermbg=none
"}}}

"dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.dein.toml'
  let s:lazy_toml = '~/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
" vimprocだけは最初にインストールしてほしい
if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif
" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif
" }}}
