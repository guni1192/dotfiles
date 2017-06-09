"行番号の表示"
set number
"tabはスペース4つ分
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

"Help Language
set helplang=ja,en

set cursorline
set mouse=a

inoremap jj <ESC>`^

" neovim terminal emulator
set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

nnoremap <silent><C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1

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

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
    execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand("~/.config/nvim/")
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'


  " toml を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

augroup FileTypeIndent
  autocmd BufNewFile,BufRead *.py   setlocal  tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.c    setlocal  tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.cpp  setlocal  tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.rb   setlocal  tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.js   setlocal  tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.html setlocal  tabstop=2 softtabstop=2 shiftwidth=2
  autocmd BufNewFile,BufRead *.css  setlocal  tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" background clear
augroup Myhighlight
  autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
  autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
  autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
  autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
  autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none 
augroup END

" syntax color setting
syntax on
colorscheme molokai

" javascript setting
augroup MyJavaScriptSetting
  autocmd FileType javascript JsPreTmpl html
augroup END

autocmd FileType c,cpp,objc map <buffer><Leader>f <Plug>(operator-clang-format)
" typescript setting
augroup MyTypeScriptSetting
  autocmd FileType typescript JsPreTmpl html
  autocmd FileType typescript syn clear foldBraces
augroup END
