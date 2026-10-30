-- gopls attaches to the gotmpl filetype. Neovim does not detect it on its own.
vim.filetype.add({
  extension = {
    tmpl = 'gotmpl',
  },
})
