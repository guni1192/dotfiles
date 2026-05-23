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

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

local bufferline = require('bufferline')
bufferline.setup{}
vim.api.nvim_set_keymap('n', '<C-n>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
