# Cursor agent config

Cursor IDE/CLI permissions, hooks, and agent skills, managed from this directory by `scripts/init.sh setup-cursor`.

| File | Managed as | Used by |
| --- | --- | --- |
| `permissions.json` | symlink → `$XDG_CONFIG_HOME/cursor/permissions.json` | Cursor IDE agent |
| `cli-config.json` | symlink → `$XDG_CONFIG_HOME/cursor/cli-config.json` | `agent` / Cursor CLI |
| `hooks.json` | symlink → `~/.cursor/hooks.json` | Cursor IDE hooks |
| `hooks/` | symlink → `~/.cursor/hooks/` | Hook scripts |
| `skills/<name>/` | symlink → `~/.cursor/skills/<name>` | Cursor IDE and CLI agent skills |

Per-repo overrides can live in `<workspace>/.cursor/permissions.json` (IDE) or `<workspace>/.cursor/cli.json` (CLI permissions only). Arrays from user and repo files are merged for IDE permissions; CLI project config layers on top of the global file.

## Hooks

User-level hooks run from `~/.cursor/`. The `stop` hook plays a system sound when an agent task finishes with `status: completed`.

Docs: https://cursor.com/docs/hooks

## Skills

Agent skills are directories under `cursor/skills/<name>/` with a `SKILL.md`. `setup-cursor` symlinks each one to `~/.cursor/skills/<name>`. Cursor IDE and CLI load user skills from that path. The frontmatter `name` must match the directory name, and `description` says what the skill does and when to use it. Optional `references/`, `scripts/`, and `assets/` sit next to `SKILL.md`.

`.claude/skills` is a symlink to `../cursor/skills`, so Claude Code still loads these as project skills and there is one copy of the files. Cursor also reads `.claude/skills/` for compatibility. That in-repo path is what cloud agents see: user-level `~/.cursor/skills/` is not copied to cloud agents, remote SSH, or BYO workers.

`~/.cursor/skills` is not replaced as a whole, so skills that do not come from this repo are left alone. A symlink this script created is removed on the next run if its skill directory is gone. New skills are picked up by Claude through the `.claude/skills` symlink immediately; run `./scripts/init.sh setup-cursor` again to link them into `~/.cursor/skills`.

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
- With `XDG_CONFIG_HOME` set (see `zshenv`), Cursor reads `permissions.json` and `cli-config.json` from `$XDG_CONFIG_HOME/cursor/`. Hooks and skills stay under `~/.cursor/` (`hooks.json`, `hooks/`, `skills/`). The skills docs list `~/.cursor/skills/` and do not use `XDG_CONFIG_HOME`.
- Cursor CLI may add runtime fields such as `model` or `authInfo` to `cli-config.json`; review git diffs before committing.
- Run `./scripts/init.sh setup-cursor` once to create symlinks. Edits to linked files take effect immediately. A new directory under `cursor/skills/` needs `setup-cursor` again before `~/.cursor/skills` includes it.
- To add MCP auto-approval in the IDE, append entries like `"github:*"` to `mcpAllowlist` in `permissions.json`.
