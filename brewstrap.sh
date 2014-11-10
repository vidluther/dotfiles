#!/bin/zsh

source "$PWD/common.sh"

#brewinstall

brew install git-extras
brew install caskroom/cask/brew-cask

# Setting up Ruby and stuff.

brew install rbenv ruby-build rbenv-gemset

brew install python
brew linkapps

mkdir ~/.config
mkdir ~/.config/powerline
