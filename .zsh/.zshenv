export ZDOTDIR="${HOME}/.zsh"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.cabal/bin:$PATH"

export PATH="/usr/local/opt/llvm/bin:$PATH"

# 256色で使うための設定
export TERM="xterm-256color"

export LANG='en_US.UTF-8'
export LC_ALL=$LANG

export NVIM=$HOME/.config/nvim

export ASDF_PYTHON_VERSION=3.6.2
export ASDF_NODEJS_VERSION=8.3.0
export ASDF_HASKELL_VERSION=8.0.2
export ASDF_Ruby_VERSION=2.4.1

# venvのプロンプト表示
export VIRTUAL_ENV_DISABLE_PROMPT=1
