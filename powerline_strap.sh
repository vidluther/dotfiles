#!/bin/zsh

set -e
personal_dropbox=/Users/vluther/Dropbox\ \(Personal\)

cd "$personal_dropbox/powerline-fonts/"
./install.sh

cd ~

# this assumes you've opened a new terminal window, and have the following
# already installed.
# 1. homebrew
# 2. python after homebrew

pip install --upgrade setuptools
pip install --upgrade pip


pip install git+git://github.com/Lokaltog/powerline


cp -R /usr/local/lib/python2.7/site-packages/powerline/config_files/* .config/powerline
