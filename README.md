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

`./scripts/init.sh` で利用可能なサブコマンド一覧を表示できる。
個別に走らせたい場合は `./scripts/init.sh setup-zsh` のように呼ぶ。

## macOS: Nix + Devbox

`scripts/init.sh` installs both for you, idempotently:

- **Nix**: via the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
  (`install --determinate --no-confirm`). Multi-user, daemon-based, Apple Silicon ready.
  On a fresh machine this creates `/nix` as an APFS volume; reopen the terminal
  after the script finishes so `nix-daemon.sh` is sourced into login shells.
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
`scripts/init.sh` symlinks it into `~/.local/share/devbox/global/default` and runs
`devbox global install`, which materializes every pinned tool into the global Nix profile.

Common commands:

```console
devbox global list                    # show installed packages
devbox global add <pkg>@<version>     # add a package (edits devbox.json)
devbox global update                  # bump versions in devbox.lock
devbox global install                 # apply devbox.json after pulling changes
```

The PATH wiring in `zshenv` evaluates `devbox global shellenv --init-hook`, so any
package added to `devbox/devbox.json` becomes available in new shells after
`devbox global install`.

#### Copilot LSP

`@github/copilot-language-server` is an npm package (not in nixpkgs). The devbox
`init_hook` installs it globally into `~/.local/npm-global/bin` the first time
the global shellenv evaluates. To force a reinstall:

```console
npm install -g @github/copilot-language-server@latest
```

### Try on docker

```console
docker run -it ghcr.io/guni1192/dotfiles:latest
```
