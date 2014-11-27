#!/bin/zsh

source "$PWD/common.sh"

echo "Installing Homebrew.. and setting up the basics. \n"

#brewinstall

brew install git-extras graphviz
brew install caskroom/cask/brew-cask

newrubies()

# Setting up Ruby and stuff.

brew install rbenv ruby-build rbenv-gemset rbenv-vars rbenv-gem-rehash

echo "Checking if Ruby $RUBY_VERSION is already in $RUBIES_PATH"

if [ -z "$RUBIES_PATH" ];
then

             rbenv install $RUBY_VERSION
fi

rbenv global $RUBY_VERSION
rbenv exec gem install bundler test-kitchen kitchen-vagrant berkshelf
