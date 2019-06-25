#!/usr/bin/env bash
-bash: complete: -D: invalid option


brew install core utils
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash

 CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install 3.7.0

 #Install font, emacs, iterm2, macpass, pyenv etc.

 pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U


 brew install binutils
brew install diffutils
brew install ed
brew install findutils
brew install gawk
brew install gnu-indent
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install gnutls
brew install grep
brew install gzip
brew install screen
brew install watch
brew install wdiff
brew install wget
