# dotfiles

## Environment

- Ubuntu 22.04
- macOS

## Tools

- zsh
- tmux
- neovim
- [mise](https://mise.jdx.dev/)
- aqua

## Getting Started

```console
git clone https://github.com/guni1192/dotfiles.git
cd dotfiles
./scripts/init.sh
```

### mise

Install:

```console
./scripts/install-mise.sh
```

Update:

```console
mise self-update
# or re-run the install script
./scripts/install-mise.sh
```

mise のバージョンは [Renovate](https://docs.renovatebot.com/) により自動で更新 PR が作成されます。

### Try on docker

```console
docker run -it ghcr.io/guni1192/dotfiles:latest
```
