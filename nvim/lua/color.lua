vim.cmd("syntax on")
vim.api.nvim_create_augroup('BgColor', {})
vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
    pattern = {'*'},
    group = 'BgColor',
    command = 'highlight Normal ctermbg=none'
})
vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
    pattern = {'*'},
    group = 'BgColor',
    command = 'highlight LineNr ctermbg=none'
})
vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
    pattern = {'*'},
    group = 'BgColor',
    command = 'highlight SignColumn ctermbg=none'
})
vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
    pattern = {'*'},
    group = 'BgColor',
    command = 'highlight VertSplit ctermbg=none'
})
vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
    pattern = {'*'},
    group = 'BgColor',
    command = 'highlight NonText ctermbg=none'
})


vim.cmd("colorscheme kalisi")
vim.opt.background = "dark"

