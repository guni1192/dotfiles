# Cursor agent permissions

Cursor IDE/CLI config and user hooks, managed from this directory by `scripts/init.sh setup-cursor`.

| File | Managed as | Used by |
| --- | --- | --- |
| `permissions.json` | symlink → `$XDG_CONFIG_HOME/cursor/permissions.json` | Cursor IDE agent |
| `cli-config.json` | symlink → `$XDG_CONFIG_HOME/cursor/cli-config.json` | `agent` / Cursor CLI |
| `hooks.json` | symlink → `~/.cursor/hooks.json` | Cursor IDE hooks |
| `hooks/` | symlink → `~/.cursor/hooks/` | Hook scripts |

Per-repo overrides can live in `<workspace>/.cursor/permissions.json` (IDE) or `<workspace>/.cursor/cli.json` (CLI permissions only). Arrays from user and repo files are merged for IDE permissions; CLI project config layers on top of the global file.

## Hooks

User-level hooks run from `~/.cursor/`. The `stop` hook plays a system sound when an agent task finishes with `status: completed`.

Docs: https://cursor.com/docs/hooks

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
- Cursor CLI may add runtime fields such as `model` or `authInfo` to `cli-config.json`; review git diffs before committing.
- Run `./scripts/init.sh setup-cursor` once to create symlinks; edits under `cursor/` take effect immediately.
- To add MCP auto-approval in the IDE, append entries like `"github:*"` to `mcpAllowlist` in `permissions.json`.
