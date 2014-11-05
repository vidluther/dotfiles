#!/bin/zsh

#set -e
#set -x

personal_dropbox=/Users/vluther/Dropbox\ \(Personal\)
# This script will setup some command line things that I use often.

# Vagrant (assuming vagrant is installed)

vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-vmware-fusion

cd $personal_dropbox
vagrant plugin license vagrant-vmware-fusion vagrant-vmware-7.lic
