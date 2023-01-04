FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
LABEL org.opencontainers.image.source https://github.com/guni1192/dotfiles

RUN apt-get update -y \
    && apt-get install -y \
    zsh \
    tmux \
    vim \
    git \
    locales \
    apt-transport-https \
    ca-certificates \
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
    doxygen \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

RUN useradd guni -s /usr/bin/zsh -m -d /home/guni

USER guni

RUN git clone https://github.com/neovim/neovim /home/guni/neovim-src && \
    cd /home/guni/neovim-src && \
    make CMAKE_INSTALL_PREFIX=/home/guni/.local && \
    make install && \
    rm -rf /home/guni/neovim-src

WORKDIR /home/guni/dotfiles

COPY --chown=guni . .

RUN ./scripts/init.sh

ENTRYPOINT ["/usr/bin/zsh"]
