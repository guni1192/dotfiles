# devcontainer (verification environment)

Spins up an Ubuntu 22.04 container and runs `./scripts/init.sh`, which installs
Nix + Devbox from scratch (no devcontainer features) and then applies the dotfiles.

## Usage

- **VS Code / Cursor**: open the repo and run `Dev Containers: Reopen in Container`.
- **CLI**:

  ```console
  devcontainer up --workspace-folder .
  devcontainer exec --workspace-folder . zsh
  ```

The workspace is bind-mounted to `/home/vscode/dotfiles` so the `~/dotfiles/...`
paths inside `scripts/init.sh` resolve without modification.

## What gets installed

| Layer | Source |
| --- | --- |
| Nix (single-user, no daemon) | `scripts/init.sh` → upstream `nix/install --no-daemon` |
| Devbox | `scripts/init.sh` → `get.jetify.com/devbox` |
| All `devbox/devbox.json` packages | `devbox global install` (run by `init.sh`) |
| dotfiles (zsh, nvim, tmux, git, ghostty, zinit) | `scripts/init.sh` symlinks |

`setup_nix` branches by environment:

- **macOS** → Determinate installer, multi-user.
- **Linux with systemd** → Determinate installer, multi-user.
- **Linux without systemd (this container)** → upstream installer in `--no-daemon`
  single-user mode, installed under `~/.nix-profile`.

First boot materializes every Nix package in `devbox/devbox.json` — expect a few
minutes while binaries download from `cache.nixos.org`. Rebuilds reuse the Nix
store under `/nix`.

## Re-running init.sh

`init.sh` is idempotent (it skips Nix / Devbox / packages already present), so
you can re-run it inside the container after editing configs:

```console
./scripts/init.sh setup-all       # everything
./scripts/init.sh setup-devbox    # just refresh the devbox global profile
./scripts/init.sh                 # no args → print the subcommand list
```
