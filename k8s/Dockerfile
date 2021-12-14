FROM ghcr.io/guni1192/dotfiles:latest

USER root

RUN apt-get update -y \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "%guni    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/guni && \
    chmod 0440 /etc/sudoers.d/guni

WORKDIR /home/guni

USER guni
SHELL ["/usr/bin/zsh", "-c"]

COPY install-kubeutils.sh install-kubeutils.sh
RUN ./install-kubeutils.sh
