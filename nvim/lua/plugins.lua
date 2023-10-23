local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
        vim.keymap.set('n', '<C-e>', api.tree.toggle,                       opts('Toggle'))
      end
      require("nvim-tree").setup {
        on_attach = my_on_attach,
      }
    end,
  },
  {"freeo/vim-kalisi"},
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({})
    end
  },
  -- completion and snippet
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-cmdline"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/vim-vsnip"},
  -- lualine
  {'nvim-lualine/lualine.nvim'},
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
})


-- nvim-tree global keymap
local api = require "nvim-tree.api"
vim.keymap.set('n', '<C-e>', api.tree.toggle)

-- fzf-lua
vim.keymap.set("n", "<c-f><c-f>",
  "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<c-f><c-g>",
  "<cmd>lua require('fzf-lua').git_files()<CR>", { silent = true })
vim.keymap.set("n", "<c-f><c-s>",
  "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
