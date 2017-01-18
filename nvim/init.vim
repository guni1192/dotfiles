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
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:$
set statusline=2
"ノーマルモードのキーバインド"
inoremap jj <ESC>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
" NERDTreeをctrl+eで開く
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on
autocmd FileType c set cindent
autocmd FileType cpp set cindent

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set mouse=a

let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

 "もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" カラー表示
syntax on
colorscheme badwolf
autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none

let g:airline_powerline_fonts = 1
let g:airline_theme = 'badwolf'
"let g:Powerline_symbols='fancy'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:deoplete#enable_at_startup = 1
