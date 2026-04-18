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


vim.lsp.enable('rust-analyzer', {
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

vim.lsp.enable('gopls', {
  cmd = {"gopls", "serve", "-rpc.trace"},
  filetypes = {'go'},
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

-- Go: Auto-format and organize imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    vim.lsp.buf.format({ async = false })
  end
})

-- Protobuf
vim.lsp.enable('clangd', {
  filetypes = {'proto'},
})

-- Terraform
vim.lsp.enable('terraformls', {
  filetypes = {'tf', 'tfvars'},
})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Lua (lua-language-server / LuaLS)
vim.lsp.enable('lua_ls', {
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

-- GitHub Copilot via official LSP (@github/copilot-language-server).
-- Install: `npm install -g @github/copilot-language-server`
-- Sign in: `:CopilotSignIn` (device-code flow)
vim.lsp.config('copilot', {
  cmd = { 'copilot-language-server', '--stdio' },
  filetypes = {
    'lua', 'go', 'rust', 'python',
    'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
    'sh', 'bash', 'zsh',
    'terraform', 'hcl', 'proto',
    'markdown', 'yaml', 'json', 'jsonc',
    'html', 'css',
    'c', 'cpp',
  },
  root_markers = { '.git' },
  init_options = {
    editorInfo       = { name = 'Neovim', version = tostring(vim.version()) },
    editorPluginInfo = { name = 'copilot-lsp', version = '1.0.0' },
  },
  settings = {
    telemetry = { telemetryLevel = 'off' },
  },
  on_attach = function(_, bufnr)
    vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    vim.keymap.set('i', '<C-g>', function()
      if not vim.lsp.inline_completion.get() then
        return '<CR>'
      end
    end, { expr = true, buffer = bufnr, desc = 'Copilot: accept inline completion' })
    vim.keymap.set('i', '<M-]>', function()
      vim.lsp.inline_completion.select({ count = 1 })
    end, { buffer = bufnr, desc = 'Copilot: next suggestion' })
    vim.keymap.set('i', '<M-[>', function()
      vim.lsp.inline_completion.select({ count = -1 })
    end, { buffer = bufnr, desc = 'Copilot: previous suggestion' })
  end,
})
vim.lsp.enable('copilot')

vim.api.nvim_create_user_command('CopilotSignIn', function()
  local client = vim.lsp.get_clients({ name = 'copilot' })[1]
  if not client then
    return vim.notify('copilot LSP not running', vim.log.levels.ERROR)
  end
  client:request('signIn', vim.empty_dict(), function(err, res)
    if err or not res then
      return vim.notify('signIn failed: ' .. vim.inspect(err), vim.log.levels.ERROR)
    end
    vim.fn.setreg('+', res.userCode)
    vim.notify(('Copilot code: %s (copied to +). Open https://github.com/login/device'):format(res.userCode))
    if res.command then
      client:exec_cmd(res.command)
    end
  end)
end, {})

vim.api.nvim_create_user_command('CopilotSignOut', function()
  local client = vim.lsp.get_clients({ name = 'copilot' })[1]
  if client then
    client:request('signOut', vim.empty_dict(), function()
      vim.notify('Copilot: signed out')
    end)
  end
end, {})
