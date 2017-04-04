"行番号の表示"
set number
"tabはスペース4つ分"
set tabstop=2
set softtabstop=2
"tabで半角スペースで挿入する"
set expandtab
"Vimが自動で生成するtabをスペース4つ分にする"
set shiftwidth=2
"改行時、自動でインデント"
set smartindent
"オートインデントをオン
set autoindent
"空白文字の可視化"
set list
"可視化した空白文字の表示形式"
set listchars=tab:--,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
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
set clipboard+=unnamedplus
"単語補完の入力候補の最大数"
set pumheight=10
set showmode
set wildmode=list:full
set laststatus=2
set cursorline

set mouse=a


"ノーマルモードのキーバインド"
inoremap jj <ESC>`^
"

" NERDTreeをctrl+eで開く
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on
augroup FlleIndent
  autocmd FileType c set cindent
  autocmd FileType cpp set cindent
augroup END

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif


let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイルを用意しておく
  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " toml を読み込み、キャッシュしておく
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

augroup Myhighlight
  autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
  autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
  autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
  autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
  autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none 
augroup END


syntax on
colorscheme molokai
let python_highlight_all = 1
