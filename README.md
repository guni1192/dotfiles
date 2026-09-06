# dotfiles

## Environment

- Ubuntu 22.04
- macOS

## Tools

- zsh
- tmux
- [Herdr](https://herdr.dev/)
- neovim
- CLI tool managers (pick one at initial setup):
  - [Nix](https://nixos.org/) + [Devbox](https://www.jetify.com/devbox) via `setup-all-with-devbox`
  - [aqua](https://aquaproj.github.io/) via `setup-all-with-aqua`

## Getting Started

```console
git clone https://github.com/guni1192/dotfiles.git
cd dotfiles

# Choose one tool manager for the initial setup:
./scripts/init.sh setup-all-with-devbox   # or: --setup-all-with-devbox
./scripts/init.sh setup-all-with-aqua     # or: --setup-all-with-aqua
```

`setup-all` remains as an alias for `setup-all-with-devbox`.

Run `./scripts/init.sh` with no arguments to print the available subcommands,
and invoke one individually with e.g. `./scripts/init.sh setup-zsh`.
A leading `--` is optional.

## Nix + Devbox

`scripts/init.sh setup-all-with-devbox` installs both idempotently:

- **Nix**: via the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
  in upstream CE mode (not `--determinate`, to stay compatible with leftover
  upstream installs). Falls back to `--no-daemon` single-user mode in containers
  without systemd.
- **Devbox**: via `get.jetify.com/devbox`, pinning tool versions in `devbox.json`.

### Global profile

This repo ships a global devbox profile at `devbox/devbox.json`.
`scripts/init.sh setup-devbox` creates `~/.local/share/devbox/global/default`
as a real directory, symlinks `devbox.json` and `devbox.lock` into it (so the
per-environment `.devbox/` state — which contains absolute `/nix/store` paths
— stays local to each host and container), and runs `devbox global install`.

`zsh/devbox.zsh` evaluates `devbox global shellenv` for interactive shells, so
packages added to `devbox/devbox.json` become available in new shells after
`devbox global install`.

#### Copilot LSP

`@github/copilot-language-server` is an npm package (not in nixpkgs). The
devbox `init_hook` installs it globally into `~/.local/npm-global/bin`; it is
evaluated once by `scripts/init.sh setup-devbox` after `devbox global install`
completes.

## aqua (Nix/Devbox alternative)

If you prefer not to install Nix, use the aqua path for initial setup:

```console
./scripts/init.sh setup-all-with-aqua   # or: --setup-all-with-aqua
```

Or refresh tools only with `./scripts/init.sh setup-aqua`.

`setup-aqua` installs aqua via [aqua-installer](https://github.com/aquaproj/aqua-installer),
symlinks `aquaproj-aqua/` into `$XDG_CONFIG_HOME/aquaproj-aqua`, and runs
`aqua install -a` against the global config.

`aquaproj-aqua/aqua.yaml` mirrors the CLI set in `devbox/devbox.json` (pinned
versions where Devbox pins them; concrete pins for Devbox `@latest` packages).
Packages not published in aqua-registry (`flarectl`, `cursor-cli`, `devcontainer`)
remain Devbox-only.

`zshenv` prepends aqua's bin dir and sets `AQUA_GLOBAL_CONFIG`, so tools are on
`PATH` in new shells after install. Do not run both Devbox and aqua global
profiles unless you intend overlapping tool versions on `PATH`.

## Herdr

Installed by both tool managers, pinned to 0.8.2:

- Devbox: `herdr@0.8.2` in `devbox/devbox.json` (nixpkgs `herdr`)
- aqua: `herdrdev/herdr@v0.8.2` in `aquaproj-aqua/aqua.yaml`

`scripts/init.sh setup-herdr` (also run by `setup-all*`) symlinks
`herdr/config.toml` into `$XDG_CONFIG_HOME/herdr/config.toml`.

Only the config file is linked. Herdr keeps logs, sockets, and `session.json`
next to it, so the whole `~/.config/herdr` directory stays local.

Prefix is `Ctrl+J`, matching `tmux/tmux.conf`. Reload a running server with
`herdr server reload-config` (or `prefix+Ctrl+R`).

## Cursor agent permissions

`scripts/init.sh setup-cursor` symlinks `cursor/permissions.json`,
`cursor/cli-config.json`, `cursor/hooks.json`, and `cursor/hooks/` into
`$XDG_CONFIG_HOME/cursor/` and `~/.cursor/`. See [cursor/README.md](./cursor/README.md)
for the IDE vs CLI permission models and how to customize allow/deny rules.

## Dev Container

See [.devcontainer/README.md](./.devcontainer/README.md) for trying this repo in a Dev Container.
