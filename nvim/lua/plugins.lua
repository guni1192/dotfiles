local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
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

        api.config.mappings.default_on_attach(bufnr)

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
  -- LSP
  {"neovim/nvim-lspconfig"},
  -- statusline / tabline
  {'nvim-lualine/lualine.nvim'},
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { "EdenEast/nightfox.nvim" },
  -- treesitter (main branch, Neovim 0.12+ API)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ensure = {
        "bash", "c", "diff", "go", "hcl", "html",
        "javascript", "jsdoc", "json", "jsonc",
        "lua", "luadoc", "luap",
        "markdown", "markdown_inline",
        "python", "query", "regex", "rust",
        "terraform", "toml", "tsx", "typescript",
        "vim", "vimdoc", "xml", "yaml", "jsonnet"
      }
      require('nvim-treesitter').install(ensure)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = ensure,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
        select = { lookahead = true },
      })

      local move = require("nvim-treesitter-textobjects.move")
      local function map(lhs, fn, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, fn, { desc = desc })
      end
      map("]f", function() move.goto_next_start("@function.outer", "textobjects") end, "Next function start")
      map("]c", function() move.goto_next_start("@class.outer", "textobjects") end, "Next class start")
      map("]F", function() move.goto_next_end("@function.outer", "textobjects") end, "Next function end")
      map("]C", function() move.goto_next_end("@class.outer", "textobjects") end, "Next class end")
      map("[f", function() move.goto_previous_start("@function.outer", "textobjects") end, "Prev function start")
      map("[c", function() move.goto_previous_start("@class.outer", "textobjects") end, "Prev class start")
      map("[F", function() move.goto_previous_end("@function.outer", "textobjects") end, "Prev function end")
      map("[C", function() move.goto_previous_end("@class.outer", "textobjects") end, "Prev class end")
    end,
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
