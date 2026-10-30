# Known checkhealth patterns in this dotfiles repo

Recurring issues observed and how they were resolved. Add new entries when you encounter new patterns — that's what keeps this skill useful.

## Neovim 0.12: `vim.lsp.enable(name, config)` no longer applies inline config

**Symptom (in `:checkhealth vim.lsp`):**

```
- ⚠️ WARNING 'rust-analyzer' config not found. Ensure that vim.lsp.config('rust-analyzer') was called.
```

Or, more subtly: server attaches but its `settings`/`filetypes`/`cmd` overrides don't take effect (e.g., gopls runs without your `-rpc.trace`, `gofumpt`, `staticcheck` settings).

**Cause:** In Neovim 0.12, `vim.lsp.enable(name, config)` was split. `enable` now only turns the server on; the config registration moved to `vim.lsp.config(name, config)`.

**Fix in `nvim/lua/lsp.lua`:** for every server, change

```lua
vim.lsp.enable('gopls', {
  filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
  settings = { ... },
})
```

to

```lua
vim.lsp.config('gopls', {
  filetypes = {'go', 'gomod', 'gowork', 'gotmpl'},
  settings = { ... },
})
vim.lsp.enable('gopls')
```

Apply uniformly across all servers (rust_analyzer, gopls, terraformls, lua_ls, …). Reference commit: `830b474`.

The config **name** must match `lsp/<name>.lua` from nvim-lspconfig. `vim.lsp.config` loads that file by name and merges it. `rust-analyzer` does not match `lsp/rust_analyzer.lua`, so the resolved config has no `cmd` and the server never starts. Call `vim.lsp.config('rust_analyzer', …)` and `vim.lsp.enable('rust_analyzer')`. The settings table key stays `['rust-analyzer']` (that is the server's own namespace, not the config name).

## terraformls: `tf` / `tfvars` are not the Neovim filetypes

**Symptom (in `:checkhealth vim.lsp`):**

```
⚠️ WARNING Unknown filetype 'tfvars' (Hint: filename extension != filetype).
```

`tf` is not warned about, because it is a real filetype (TinyFugue). terraform-ls still does not attach to `*.tf` buffers.

**Cause:** Neovim detects `*.tf` as `terraform` and `*.tfvars` as `terraform-vars`. nvim-lspconfig's `terraformls` uses those names. Overriding `filetypes` with `tf` and `tfvars` replaces them.

**Fix in `nvim/lua/lsp.lua`:**

```lua
vim.lsp.config('terraformls', {
  filetypes = { 'terraform', 'terraform-vars' },
})
```

## nvim-treesitter: `jsonc` is not an installable parser

**Symptom (on startup):**

```
[nvim-treesitter] warning: skipping unsupported language: jsonc
```

**Cause:** Current nvim-treesitter (main) has no `jsonc` parser. `plugin/filetypes.lua` registers the `json` parser for the `jsonc` filetype.

**Fix in `nvim/lua/plugins.lua`:** pass `json` to `require('nvim-treesitter').install`, and keep `jsonc` only on the `FileType` autocmd that calls `vim.treesitter.start()`.

## lazy.nvim: luarocks/hererocks ERROR when no plugin needs it

**Symptom (in `:checkhealth lazy`):**

```
❌ ERROR {.../lazy-rocks/hererocks/bin/luarocks} not installed
⚠️ WARNING {.../lazy-rocks/hererocks/bin/lua} version `5.1` not installed
⚠️ WARNING Lazy won't be able to install plugins that require `luarocks`.
```

**Cause:** lazy.nvim probes for hererocks-managed luarocks even if no plugin declares a rocks dependency.

**Fix in `nvim/lua/plugins.lua`:** pass `rocks = { enabled = false }` as the second argument to `lazy.setup`:

```lua
lazy.setup({
  -- plugin specs...
}, {
  rocks = { enabled = false },
})
```

Only do this after confirming no installed plugin requires luarocks (`:checkhealth lazy` says "no plugins require luarocks, so you can ignore any warnings below" when safe).

## gopls: lsp.log bloated to hundreds of MB

**Symptom (in `:checkhealth vim.lsp`):**

```
⚠️ WARNING Log size: 133045 KB
```

**Cause:** A debug/trace flag left on gopls's `cmd`, e.g. `cmd = {"gopls", "serve", "-rpc.trace"}`. `-rpc.trace` dumps every JSON-RPC frame to the log.

**Fix in `nvim/lua/lsp.lua`:** drop the verbose flags from `cmd`, or omit `cmd` entirely to let nvim-lspconfig use the default. Then truncate the log:

```bash
: > ~/.local/state/nvim/lsp.log
```

## "Unknown filetype X" for files an LSP should handle

**Symptom (in `:checkhealth vim.lsp`):**

```
⚠️ WARNING Unknown filetype 'gotmpl' (Hint: filename extension != filetype).
```

**Cause:** The LSP server config names a filetype Neovim doesn't auto-detect, and there's no `vim.filetype.add` mapping for it.

**Fix:** either (a) add the mapping in `nvim/lua/filetype.lua` so the extension resolves to that filetype, or (b) drop the filetype from the LSP's `filetypes` list if you don't actually edit those files. This repo keeps gotmpl on gopls and maps it:

```lua
vim.filetype.add({
  extension = { tmpl = 'gotmpl' },
})
```

`init.lua` must `require('filetype')` before `require('lsp')`. Do not put indent settings back in `filetype.lua`; those live in `after/ftplugin/`.

## Optional media previewers (fzf-lua) — usually skip

**Symptom (in `:checkhealth fzf_lua`):**

```
⚠️ WARNING 'viu' not found
⚠️ WARNING 'chafa' not found
⚠️ WARNING 'ueberzugpp' not found
```

**Cause:** fzf-lua's optional image-preview backends aren't installed.

**Action:** typically **skip**. These are only needed if the user wants image previews in fzf-lua pickers. Don't install them just to silence the warning — confirm with the user first.
