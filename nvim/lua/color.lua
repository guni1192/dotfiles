vim.cmd("syntax on")
vim.cmd("autocmd ColorScheme * highlight Normal ctermbg=none")
vim.cmd("autocmd ColorScheme * highlight LineNr ctermbg=none")

-- " background clear
-- augroup Myhighlight
--     autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
--     autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
--     autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
--     autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
--     autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none 
-- augroup END


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

