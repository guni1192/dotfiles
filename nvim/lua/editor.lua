vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.list = true
vim.opt.listchars= 'tab:>-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%'
vim.opt.hidden = true
vim.opt.history = 50
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"
vim.opt.backspace = "indent,eol,start"
vim.opt.wildmenu = true
vim.opt.clipboard = "unnamed"
vim.opt.pumheight = 10
vim.opt.showmode = true
vim.opt.wildmode = "list:full"
vim.opt.encoding = "utf-8"
vim.opt.helplang = "en"
vim.opt.cursorline = true
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 100

-- Native insert-mode autocomplete (Neovim 0.12+). LSP sources via omnifunc
-- are wired automatically on LspAttach.
vim.o.autocomplete = true

-- <Tab>: accept Copilot ghost text, else confirm popup completion, else insert Tab.
vim.keymap.set('i', '<Tab>', function()
  if vim.lsp.inline_completion.get() then
    return
  end
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end
  return '<Tab>'
end, { expr = true, silent = true, desc = 'Accept Copilot/completion or insert Tab' })
