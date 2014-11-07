#!/bin/bash

set -e
set -x

ln -s ~/Dropbox\ \(Personal\)/dotfiles/bin /Users/vluther/bin
ln -s ~/Dropbox\ \(Personal\)/dotfiles/dotzshrc /Users/vluther/.zshrc
ln -s ~/Dropbox\ \(Personal\)/dotfiles/gitconfig /Users/vluther/.gitconfig



## My .ssh stuff. Also not public for obvious reasons.

ln -s ~/Dropbox\ \(Personal\)/pcli/ssh /Users/vluther/.ssh
ln -s ~/Dropbox\ \(Personal\)/pcli/apikeys.sh /Users/vluther/.apikeys.sh

# Powerline stuff.. still undecided about how useful it is.

# Docs here: https://powerline.readthedocs.org/en/latest/usage.html
pip install git+git://github.com/Lokaltog/powerline
