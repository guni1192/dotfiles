# Cursor agent permissions

Cursor has two separate permission systems, managed from this directory by `scripts/init.sh setup-cursor`.

| File | Managed as | Used by |
| --- | --- | --- |
| `permissions.json` | symlink → `$XDG_CONFIG_HOME/cursor/permissions.json` | Cursor IDE agent |
| `cli-config.json` | copied to `$XDG_CONFIG_HOME/cursor/cli-config.json` | `agent` / Cursor CLI |

Per-repo overrides can live in `<workspace>/.cursor/permissions.json` (IDE) or `<workspace>/.cursor/cli.json` (CLI permissions only). Arrays from user and repo files are merged for IDE permissions; CLI project config layers on top of the global file.

## IDE (`permissions.json`)

Controls terminal/MCP allowlists and Auto-review classifier hints.

- `terminalAllowlist` / `mcpAllowlist`: commands or `server:tool` patterns that run without approval. When present, they replace the in-app allowlist for that type (IDE entries are not merged in).
- `autoRun.allow_instructions` / `autoRun.block_instructions`: natural-language hints for Auto-review mode only.

Docs: https://cursor.com/docs/reference/permissions

## CLI (`cli-config.json`)

Structured allow/deny tokens for the CLI agent (`agent`, `agent -p`, etc.).

- `Shell(commandBase)` / `Shell(command:argsGlob)` — shell commands
- `Read(pathGlob)` / `Write(pathGlob)` — file access
- `WebFetch(domainPattern)` — web fetch tool
- `Mcp(server:tool)` — MCP tools

Deny rules take precedence over allow rules.

Docs: https://cursor.com/docs/cli/reference/permissions

## Notes

- Run Mode must be enabled in Cursor Settings for `permissions.json` to apply.
- With `XDG_CONFIG_HOME` set (see `zshenv`), Cursor reads these files from `$XDG_CONFIG_HOME/cursor/` rather than `~/.cursor/`.
- `cli-config.json` is copied from dotfiles on each `setup-cursor` run (overwrites the local file). Cursor CLI may add runtime fields such as `model` or `authInfo` afterward; those stay local and are not tracked in this repo.
- Re-run `./scripts/init.sh setup-cursor` after editing either file in this directory.
- To add MCP auto-approval in the IDE, append entries like `"github:*"` to `mcpAllowlist` in `permissions.json`.
