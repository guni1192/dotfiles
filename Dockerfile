FROM ubuntu:20.04

RUN apt-get update -y \
    && apt-get install -y \
    zsh \
    tmux \
    vim \
    git \
    locales \
    curl \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
RUN useradd guni -s /usr/bin/zsh -m -d /home/guni

USER guni

RUN git clone https://github.com/zplug/zplug ~/.zplug

WORKDIR /home/guni/dotfiles

COPY . .

RUN ./init.sh

ENTRYPOINT ["/usr/bin/zsh"]
