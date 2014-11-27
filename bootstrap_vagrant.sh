#!/bin/zsh


source "$PWD/common.sh"

brew install homebrew/binary/packer


# This script will setup some command line things that I use often.

echo "Setting Up stuff related to Dev Ops"
# Vagrant (assuming vagrant is installed)

vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-vmware-fusion
vagrant plugin install vagrant-omnibus

cp $DOTFILES/Vagrantfile ~/.vagrant.d/

cd $personal_dropbox
vagrant plugin license vagrant-vmware-fusion vagrant-vmware-7.lic
