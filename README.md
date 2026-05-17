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

## macOS: Nix + Devbox

`scripts/init.sh` installs both for you, idempotently:

- **Nix**: via the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
  (`install --no-confirm`, installing upstream Nix CE — we deliberately skip
  `--determinate` to keep the nixbld group compatible with any leftover
  upstream installs). Multi-user, daemon-based, Apple Silicon ready. On a
  fresh machine this creates `/nix` as an APFS volume; reopen the terminal
  after the script finishes so `nix-daemon.sh` is sourced into login shells.
  In containers without systemd, `setup_nix` falls back to the upstream
  installer in `--no-daemon` single-user mode.
- **Devbox**: via `get.jetify.com/devbox`, a thin wrapper over Nix that pins tool
  versions in `devbox.json`.

To verify after `init.sh`:

```console
nix --version
devbox version
devbox global list
```

### Devbox global profile

This repo ships a global devbox profile at `devbox/devbox.json`.
`scripts/init.sh setup-devbox` creates `~/.local/share/devbox/global/default`
as a real directory, symlinks `devbox.json` and `devbox.lock` into it (so the
per-environment `.devbox/` state — which contains absolute `/nix/store` paths
— stays local to each host and container), and runs `devbox global install`
to materialize every pinned tool into the global Nix profile.

Common commands:

```console
devbox global list                    # show installed packages
devbox global add <pkg>@<version>     # add a package (edits devbox.json)
devbox global update                  # bump versions in devbox.lock
devbox global install                 # apply devbox.json after pulling changes
```

`zsh/devbox.zsh` evaluates `devbox global shellenv` for interactive shells, so
any package added to `devbox/devbox.json` becomes available in new shells
after `devbox global install`.

#### Copilot LSP

`@github/copilot-language-server` is an npm package (not in nixpkgs). The
devbox `init_hook` installs it globally into `~/.local/npm-global/bin`; it is
evaluated once by `scripts/init.sh setup-devbox` after `devbox global install`
completes. To force a reinstall:

```console
npm install -g @github/copilot-language-server@latest
```

### Try on docker

```console
docker run -it ghcr.io/guni1192/dotfiles:latest
```
