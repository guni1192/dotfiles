filetype plugin indent on
augroup FlleIndent
    autocmd FileType c set cindent
    autocmd FileType cpp set cindent
augroup END

augroup FileTypeSetting
    autocmd BufNewFile,BufRead Gemfile setlocal filetype=ruby
    autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby
augroup END

augroup FileTypeIndent
    autocmd BufNewFile,BufRead *.rs   setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
    autocmd BufNewFile,BufRead *.py   setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.go   setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
    autocmd BufNewFile,BufRead *.c    setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.cpp  setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb   setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yml  setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js   setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue  setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.erb  setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css  setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" background clear
augroup Myhighlight
    autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
    autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
    autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
    autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
    autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none 
augroup END

augroup PythonLspAutoFormatting
    autocmd!
    autocmd BufWritePre *.py LspDocumentFormatSync
augroup END
