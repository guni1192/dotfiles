#!/usr/bin/env bash

set -euxo pipefail

sudo apt-get update -y

sudo apt-get install -y \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    unzip \
    curl \
    doxygen

rm -rf $HOME/neovim-src
git clone https://github.com/neovim/neovim $HOME/neovim-src
cd $HOME/neovim-src

make CMAKE_INSTALL_PREFIX=/home/guni/.local
make install
