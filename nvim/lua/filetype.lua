vim.api.nvim_create_augroup('FileTypeIndent', {})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.rs', },
  group = 'FileTypeIndent',
  command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.lua', '*.yaml', '*.yml', '*.html', '*.css', '*.js', '*.jsx', '*.ts', '*.tsx'},
  group = 'FileTypeIndent',
  command = 'setlocal tabstop=2 softtabstop=2 shiftwidth=2'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.go'},
  group = 'FileTypeIndent',
  command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.md',},
  group = 'FileTypeIndent',
  command = 'setlocal tabstop=2 softtabstop=2 shiftwidth=2'
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  pattern = {'*.tf',},
  group = 'FileTypeIndent',
  command = 'setlocal tabstop=2 softtabstop=2 shiftwidth=2'
})

