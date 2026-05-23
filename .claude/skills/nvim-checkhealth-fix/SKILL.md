---
name: nvim-checkhealth-fix
description: Run `:checkhealth` against this dotfiles repo's Neovim config, triage the report, and fix real config issues in `nvim/`. Use whenever the user asks to "check nvim health", "debug nvim/LSP/plugin issues", "fix checkhealth warnings", mentions errors in `:checkhealth`, complains that an LSP server isn't applying its settings, sees `lsp.log` growing huge, or sees deprecation/API warnings after a Neovim upgrade — even if they don't explicitly say "checkhealth".
---

# nvim-checkhealth-fix

This skill captures the loop used to fix Neovim config issues surfaced by `:checkhealth` in this dotfiles repo. The config lives in `nvim/`:

```
nvim/
├── init.lua
├── lazy-lock.json
└── lua/
    ├── appearance.lua
    ├── editor.lua
    ├── filetype.lua
    ├── lsp.lua          # vim.lsp.config / vim.lsp.enable per server
    └── plugins.lua      # lazy.nvim setup
```

## Workflow

### 1. Capture a fresh checkhealth report

Headless capture is the most reliable. The repo convention is to drop the report at `nvim-checkhealth.txt` at the repo root (gitignored / untracked — never commit it):

```bash
nvim --headless +"checkhealth" +"write! nvim-checkhealth.txt" +"qa"
```

If a recent `nvim-checkhealth.txt` already exists at the repo root, ask the user whether it reflects the current state or should be regenerated. After fixes, always regenerate before declaring success.

### 2. Triage the report

Sections are delimited by `=========` headers (one per checked component). The interesting markers:

- `❌ ERROR` — almost always actionable.
- `⚠️ WARNING` — sometimes actionable, sometimes "missing optional dep the user doesn't want".
- `✅ OK` — ignore.

`grep -nE "^==|❌|WARNING" nvim-checkhealth.txt` gives a quick index. Read the surrounding lines for each hit; the suggestion below the warning often names the exact opt to flip.

Classify each finding into one of three buckets and present them to the user:

1. **Fix** — real config bug or API drift (e.g., deprecated calls, settings not applied, log bloat, unknown filetypes).
2. **Suppress** — known-noise warnings that have a documented mitigation (e.g., disable luarocks in lazy.nvim when no plugin uses it).
3. **Skip** — optional tooling the user has not opted into (e.g., `viu`/`chafa`/`ueberzugpp` for fzf-lua media preview). Don't add deps the user hasn't asked for.

For anything you're unsure about, ask before changing config — many "warnings" are intentional.

### 3. Apply fixes

Fixes almost always land in `nvim/lua/lsp.lua` or `nvim/lua/plugins.lua`. See `references/known-issues.md` for patterns observed in this repo (Neovim 0.12 LSP API migration, lazy.nvim luarocks, gopls log bloat, unknown filetypes). Add to that reference whenever you encounter a new recurring pattern — it's the institutional memory for this skill.

### 4. Verify

Re-run the headless capture from step 1 and re-grep. The findings you intended to fix should be gone; new findings should be addressed or explicitly acknowledged.

Note: `:checkhealth vim.lsp` only lists configs for LSPs whose attached buffer was opened during the session. Headless `:checkhealth` will report `config not found` for servers that haven't had a matching filetype loaded — this is expected in headless mode, not necessarily a bug. To verify those, open a file of the relevant filetype and run `:checkhealth vim.lsp` interactively.

### 5. Commit

One focused commit per coherent fix is the repo's style (see `830b474` for an example commit message). Keep the body explaining **why** — the Neovim version, the API change, the symptom that motivated the fix. Do not commit `nvim-checkhealth.txt`.

## Communicating with the user

Lead with the triage summary, not the raw report. Something like:

> Found 1 error and 4 warnings. Proposed actions:
> - **Fix**: `vim.lsp.enable(name, cfg)` deprecated in 0.12 → migrate 5 servers to `vim.lsp.config` + `vim.lsp.enable`
> - **Fix**: gopls log is 133MB → drop the `-rpc.trace` flag
> - **Suppress**: luarocks not installed → disable in lazy.nvim opts since no plugin needs it
> - **Skip**: `viu`/`chafa`/`ueberzugpp` missing — these are optional fzf-lua media previewers; only install if you want image preview in pickers
>
> Want me to proceed with the Fix + Suppress items?

This lets the user veto noise classifications and avoids over-fixing.

## Anti-patterns

- **Don't add optional dependencies the user hasn't opted into** just to silence warnings. fzf-lua's media warnings are the canonical example.
- **Don't paper over deprecation warnings** with `vim.deprecate = function() end` or similar — fix the calling code.
- **Don't enable luarocks/hererocks** unless a plugin actually requires it. The repo's convention is `rocks = { enabled = false }` in lazy.nvim setup.
- **Don't trust "config not found" in headless output alone** — verify interactively before assuming a server config isn't loading.
