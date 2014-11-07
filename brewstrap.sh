#!/bin/zsh

#set -e
#set -x

personal_dropbox=/Users/vluther/Dropbox\ \(Personal\)

DOTFILES="$personal_dropbox/dotfiles"

source "$DOTFILES/aliases.sh"

echo "Installing Homebrew.. and setting up the basics. \n"
brewinstall

brew install git-extras
brew install caskroom/cask/brew-cask

# This script will setup some command line things that I use often.

echo "Setting Up stuff related to Dev Ops"
# Vagrant (assuming vagrant is installed)

vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-vmware-fusion


cd $personal_dropbox
vagrant plugin license vagrant-vmware-fusion vagrant-vmware-7.lic

brew install homebrew/binary/packer

brew install rbenv ruby-build rbenv-gemset

brew install python
brew linkapps

mkdir ~/.config
mkdir ~/.config/powerline
