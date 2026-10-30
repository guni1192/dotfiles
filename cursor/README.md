# Cursor agent config

Cursor IDE/CLI permissions and hooks, managed from this directory by `scripts/init.sh setup-cursor`. Project agent skills live in `.cursor/skills/`.

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

## Skills

Project skills are `.cursor/skills/<name>/SKILL.md`. Cursor IDE and CLI load that directory from the workspace, including cloud agents. `name` must match the directory name, and `description` says what the skill does and when to use it. Optional `references/`, `scripts/`, and `assets/` sit next to `SKILL.md`.

This repo keeps that as the only copy. The skill here is about this repo's Neovim config, so it belongs with the project rather than in `cursor/skills/` or `~/.cursor/skills/`. Those user-level paths apply in every project, and Cursor would also load them a second time inside this repo. `setup-cursor` does not install project skills. If it previously linked `~/dotfiles/cursor/skills/<name>` into `~/.cursor/skills`, it removes those links.

Docs: https://cursor.com/docs/skills

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
- With `XDG_CONFIG_HOME` set (see `zshenv`), Cursor reads `permissions.json` and `cli-config.json` from `$XDG_CONFIG_HOME/cursor/`. Hooks stay under `~/.cursor/` (`hooks.json`, `hooks/`).
- Cursor CLI may add runtime fields such as `model` or `authInfo` to `cli-config.json`; review git diffs before committing.
- Run `./scripts/init.sh setup-cursor` once to create symlinks. Edits to linked files take effect immediately.
- To add MCP auto-approval in the IDE, append entries like `"github:*"` to `mcpAllowlist` in `permissions.json`.
