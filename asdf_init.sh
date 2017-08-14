#!/usr/bin/bash
asdf plugin-add haskell https://github.com/vic/asdf-haskell.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf plugin-add ruby https://github.com/asbf-vm/asdf-ruby.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin-update --all

export GNUPGHOME="${ASDF_DIR:-$HOME/.asdf}/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

GLOBAL_NODE_VERSION="8.3.0"
GLOBAL_PYTHON_VERSION="3.6.2"
GLOBAL_RUBY_VERSION="2.4.1"
GLOBAL_HASKELL_VERSION="8.0.2"

asdf install nodejs $GLOBAL_NODE_VERSION
asdf install python $GLOBAL_PYTHON_VERSION
asdf install ruby $GLOBAL_RUBY_VERSION
asdf install haskell $GLOBAL_HASKELL_VERSION

asdf global nodejs $GLOBAL_NODE_VERSION
asdf global python $GLOBAL_PYTHON_VERSION
asdf global ruby $GLOBAL_RUBY_VERSION
asdf global haskell $GLOBAL_HASKELL_VERSION

