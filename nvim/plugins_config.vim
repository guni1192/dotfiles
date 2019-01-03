" NERDTree
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1

" Jq (JSON Shaper)
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction

" Denite
nnoremap <silent> <C-k><C-f> :<C-u>Denite file_rec<CR>
nnoremap <silent> <C-k><C-g> :<C-u>Denite grep<CR>
nnoremap <silent> <C-k><C-l> :<C-u>Denite line<CR>
nnoremap <silent> <C-k><C-u> :<C-u>Denite file_mru<CR>
nnoremap <silent> <C-k><C-y> :<C-u>Denite neoyank<CR>

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
"let g:airline_theme = 'kalisi'
let g:airline_theme = 'badwolf'
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring=0
inoremap <expr><tab> pumvisible() ? "\<C-n>" :
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
if has("mac")
  let g:deoplete#sources#clang#clang_header = '/usr/local/include/'
  let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
elseif has("unix")
  let g:deoplete#sources#clang#clang_header = '/usr/include/'
  let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
endif

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

au BufRead,BufNewFile *.md set filetype=markdown

if has("mac")
  let g:previm_open_cmd = 'open -a Vivaldi'
elseif has("unix")
  let g:previm_open_cmd = 'vivaldi-snapshot'
endif

let g:go_fmt_command = "goimports"

" rust.vim
let g:rustfmt_autosave = 1

" vim-racer
let g:racer_cmd = "~/.cargo/bin/racer"

" NERDCommenter
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1

nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle
