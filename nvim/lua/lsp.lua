vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Neovim 0.11+ provides default LSP mappings:
    --   K (hover), grn (rename), gra (code action), grr (references),
    --   gri (implementation), gO (document symbol), <C-s> (signature help, insert)
    -- Only bind what's not already covered.
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


-- Name matches nvim-lspconfig's lsp/rust_analyzer.lua so cmd and root_dir merge.
-- The binary and the settings namespace stay `rust-analyzer`.
vim.lsp.config('rust_analyzer', {
  flags = {
    exit_timeout = 0,
  },
  filetypes = {'rust'},
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      checkOnSave = {
        allFeatures = true,
        command = 'clippy',
      },
      procMacro = {
        enable = true,
      },
    },
  }
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('gopls', {
  filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
vim.lsp.enable('gopls')

-- Go: Auto-format and organize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    vim.lsp.buf.format({ async = false })
  end
})

-- Neovim's filetypes are `terraform` (*.tf) and `terraform-vars` (*.tfvars).
-- `tf` is TinyFugue, not Terraform.
vim.lsp.config('terraformls', {
  filetypes = { 'terraform', 'terraform-vars' },
})
vim.lsp.enable('terraformls')

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Lua (lua-language-server / LuaLS)
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json', '.luarc.jsonc',
    '.stylua.toml', 'stylua.toml',
    'selene.toml', 'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable('lua_ls')
