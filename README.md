# Guni's dotfiles

## Environment

- macOS
- ArchLinux

## init

```bash
$ git clone git@github.com:guni1192/dotfiles.git
$ cd dotfiles
$ ./init.sh
```

## Neovim

- Package Manager: vim-plug

## LSP

### Golang

```
$ go get -u github.com/sourcegraph/go-langserver
```

### Rust

```
$ rustup update
$ rustup component add rls rust-analysis rust-src
```

## Linux Desktop

- WM: i3
- Bar: polybar
- Terminal: rxvt-unicode

```
$ yay -S i3 polybar rxvt-unicode dmenu
```

## Other

fzf, ghq

```
$ yay -S fzf ghq
```

