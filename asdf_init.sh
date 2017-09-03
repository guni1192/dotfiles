#!/usr/bin/bash
asdf plugin-add haskell https://github.com/vic/asdf-haskell.git
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf plugin-add ruby https://github.com/asbf-vm/asdf-ruby.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin-update --all

export GNUPGHOME="${ASDF_DIR:-$HOME/.asdf}/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring


asdf install nodejs   $ASDF_PYTHON_VERSION
asdf install python   $ASDF_NODEJS_VERSION
asdf install haskell  $ASDF_HASKELL_VERSION
asdf install ruby     $ASDF_Ruby_VERSION

asdf global nodejs    $ASDF_PYTHON_VERSION
asdf global python    $ASDF_NODEJS_VERSION
asdf global haskell   $ASDF_HASKELL_VERSION
asdf global ruby      $ASDF_Ruby_VERSION

