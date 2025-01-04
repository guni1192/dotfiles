FROM ubuntu:22.04

ENV TZ=Asia/Tokyo
ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
LABEL org.opencontainers.image.source=https://github.com/guni1192/dotfiles

RUN apt-get update \
    && apt-get install -y \
        zsh \
        tmux \
        git \
        locales \
        apt-transport-https \
        ca-certificates \
        unzip \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

RUN useradd guni -s /usr/bin/zsh -m -d /home/guni

USER guni

WORKDIR /home/guni/dotfiles

COPY --chown=guni . .

RUN ./scripts/neovim-installer.sh
RUN ./scripts/init.sh

ENTRYPOINT ["/usr/bin/zsh"]
