augroup filetypedetect
  au BufRead,BufNewFile *.py setfiletype python
  au BufRead,BufNewFile *.cpp setfiletype cpp
  au BufRead,BufNewFile *.rb setfiletype ruby
  au BufRead,BufNewFile *.c setfiletype c
  au BufRead,BufNewFile *.cs setfiletype csharp
augroup END
