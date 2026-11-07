# dotfiles

## Environment

- Ubuntu 22.04
- macOS (Apple Silicon). Homebrew is not used.

## Tools

- zsh
- [Herdr](https://herdr.dev/)
- neovim
- [aqua](https://aquaproj.github.io/) for CLI tools (`aquaproj-aqua/aqua.yaml`)

## Getting Started

Needs `git`, `curl`, `tar`, `zsh`, and either `sha256sum` (Linux) or `shasum` (macOS).
No Homebrew and no Nix.

```console
git clone https://github.com/guni1192/dotfiles.git
cd dotfiles
./scripts/init.sh setup-all
```

`setup-all-with-aqua` is the same command.
Run `./scripts/init.sh` with no arguments to print the subcommands,
and invoke one with e.g. `./scripts/init.sh setup-zsh`.
A leading `--` is optional.

This repo has no GitHub Actions workflow. The check is to run `setup-all` on a fresh machine.

## aqua

`scripts/init.sh setup-aqua` downloads the pinned aqua v2.65.2 release
archive for this OS and CPU from GitHub Releases. It checks the file with
`sha256sum` (Linux) or `shasum -a 256` (macOS) against a sha256 stored in
`scripts/init.sh`, and extracts the binary only after that check succeeds.
A missing checksum tool or a hash mismatch stops the script. It does not
use aqua-installer or Homebrew.
It symlinks `aquaproj-aqua/` into `$XDG_CONFIG_HOME/aquaproj-aqua` and runs
`aqua install -a`. Renovate's file preset updates `aquaproj-aqua/*.yaml`.
Bump the aqua version by editing that version and the four sha256 lines in
`scripts/init.sh`.

`zshenv` prepends aqua's bin directory and sets `AQUA_GLOBAL_CONFIG`.

Rustup is the aqua package `rust-lang/rustup`. `jq` is `jqlang/jq`.

Claude Code is not reinstalled on every `aqua install -a`. `setup-aqua` installs it
once, when `claude` is not already on `PATH`, from `aquaproj-aqua/claude.yaml`.
Updates after that follow `autoUpdatesChannel` in `claude/settings.json` (`stable`).

## Herdr

Installed by aqua, pinned to 0.9.5 (`herdrdev/herdr@v0.9.5`).

`scripts/init.sh setup-herdr` (also run by `setup-all`) symlinks
`herdr/config.toml` into `$XDG_CONFIG_HOME/herdr/config.toml`.

Only the config file is linked. Herdr keeps logs, sockets, and `session.json`
next to it, so the whole `~/.config/herdr` directory stays local.

Prefix is `Ctrl+J`. Reload a running server with
`herdr server reload-config` (or `prefix+Ctrl+R`).

## Cursor

`scripts/init.sh setup-cursor` symlinks Cursor permissions and `cli-config.json`
into `$XDG_CONFIG_HOME/cursor/`, and hooks into `~/.cursor/`. Project agent
skills are `.cursor/skills/<name>/SKILL.md` and are not installed by that
script. See [cursor/README.md](./cursor/README.md).
