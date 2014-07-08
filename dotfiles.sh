#!/bin/bash

set -e
set -x

ln -s ~/Dropbox\ \(Personal\)/dotfiles/bin /Users/vluther/sandbox/bin
ln -s ~/Dropbox\ \(Personal\)/dotfiles/dotzshrc /Users/vluther/sandbox/.zshrc
ln -s ~/Dropbox\ \(Personal\)/dotfiles/gitconfig /Users/vluther/sandbox/.gitconfig



## My .ssh stuff. Also not public for obvious reasons.

ln -s ~/Dropbox\ \(Personal\)/pcli/ssh /Users/vluther/sandbox/.ssh
ln -s ~/Dropbox\ \(Personal\)/pcli/apikeys.sh /Users/vluther/sandbox/.apikeys.sh
