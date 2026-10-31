require('vim._core.ui2').enable()

vim.opt.termguicolors = true
vim.cmd("syntax on")

vim.api.nvim_create_augroup('BgColor', {})
local transparent_groups = { 'Normal', 'LineNr', 'SignColumn', 'VertSplit', 'NonText' }
vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, {
  pattern = '*',
  group = 'BgColor',
  callback = function()
    for _, hl in ipairs(transparent_groups) do
      vim.cmd(('highlight %s guibg=NONE ctermbg=NONE'):format(hl))
    end
  end,
})

vim.cmd("colorscheme carbonfox")
vim.opt.background = "dark"
