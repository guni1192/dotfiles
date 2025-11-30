#!/usr/bin/env bash
set -e

tmpdir=$(mktemp -d)
mkdir -p "$HOME/.local"
curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar xz -C "$tmpdir"
ls -al "$tmpdir/nvim-linux-x86_64"
mv $tmpdir/nvim-linux-x86_64/* "$HOME/.local/"
