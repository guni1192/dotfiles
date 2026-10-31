local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  -- First clone uses the commit in lazy-lock.json, not the stable branch.
  local lock = vim.fn.json_decode(vim.fn.readfile(vim.fn.stdpath("config") .. "/lazy-lock.json"))
  local commit = lock["lazy.nvim"].commit
  local function fail(msg)
    vim.fn.delete(lazypath, "rf")
    vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, {})
  end
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    fail("Failed to clone lazy.nvim\n")
    return
  end
  vim.fn.system({ "git", "-C", lazypath, "checkout", "--detach", commit })
  if vim.v.shell_error ~= 0 then
    fail("Failed to checkout lazy.nvim " .. commit .. "\n")
    return
  end
end
vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
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
        -- Names only. File and folder icons stay off so startup does not load an icon font plugin.
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
              diagnostics = false,
              bookmarks = false,
            },
            web_devicons = {
              file = { enable = false, color = false },
              folder = { enable = false, color = false },
            },
          },
        },
      }
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      -- defaults.file_icons is merged into every picker on this fzf-lua version.
      require("fzf-lua").setup({
        defaults = {
          file_icons = false,
        },
      })
    end
  },
  -- LSP
  {"neovim/nvim-lspconfig"},
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
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
        "javascript", "jsdoc", "json",
        "lua", "luadoc", "luap",
        "markdown", "markdown_inline",
        "python", "query", "regex", "rust",
        "terraform", "toml", "tsx", "typescript",
        "vim", "vimdoc", "xml", "yaml", "jsonnet"
      }
      -- jsonc is not its own parser. nvim-treesitter registers the json parser for it.
      local filetypes = vim.list_extend(vim.deepcopy(ensure), { "jsonc" })
      require('nvim-treesitter').install(ensure)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}, {
  rocks = { enabled = false },
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
