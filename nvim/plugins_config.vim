" NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1

" Denite
"nnoremap <silent> <C-f><C-f> :<C-u>GFiles<CR>
nnoremap <silent> <C-f><C-f> :<C-u>Files<CR>
nnoremap <silent> <C-f><C-g> :<C-u>GFiles<CR>
nnoremap <silent> <C-f><C-l> :<C-u>Lines<CR>
nnoremap <silent> <C-f><C-c> :<C-u>Commits<CR>
nnoremap <silent> <C-f><C-a> :<C-u>Ag<CR>

" airline
set laststatus=2
"let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'badwolf'
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" asyncomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

let g:rustfmt_autosave = 1
let g:clang_format#auto_format = 1

let g:terraform_align=1
let g:terraform_fmt_on_save=1
