set number
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smartindent
set autoindent
set list
set listchars=tab:>-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set hidden
set history=50
set virtualedit=block
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set wildmenu
set clipboard=unnamed
set pumheight=10
set showmode
set wildmode=list:full
set encoding=utf-8
set helplang=ja,en
set cursorline

inoremap jj <ESC>`^

set sh=zsh
tnoremap <silent> <ESC> <C-\><C-n>
tnoremap <silent> jj <C-\><C-n>

set foldmethod=syntax
set foldlevel=100

" for Windows Terminal
if &term =~ '^xterm'
  let &t_SI .= "\<Esc>[4 q"
  let &t_EI .= "\<Esc>[2 q"
endif

set grepprg=git\ grep\ -I\ --line-number
