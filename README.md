# dotfiles

## Environment

- Ubuntu 22.04
- macOS

## Tools

- zsh
- tmux
- neovim
- [Nix](https://nixos.org/) + [Devbox](https://www.jetify.com/devbox)

## Getting Started

```console
git clone https://github.com/guni1192/dotfiles.git
cd dotfiles
./scripts/init.sh setup-all
```

Run `./scripts/init.sh` with no arguments to print the available subcommands,
and invoke one individually with e.g. `./scripts/init.sh setup-zsh`.

## Nix + Devbox

`scripts/init.sh` installs both idempotently:

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

## Dev Container

See [.devcontainer/README.md](./.devcontainer/README.md) for trying this repo in a Dev Container.
