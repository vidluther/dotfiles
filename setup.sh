#!/bin/sh
set -e
#set -x 
# First, change my shell to Zsh.
case "${SHELL}" in
  (*zsh) ;;
  (*) chsh -s "$(which zsh)"; exit 1 ;;
esac

# Load some common/shared variables and functions
source "$PWD/common.sh"



p "Setting up ~/bin"
ln -s $DOTFILES/bin /Users/vluther/bin
p "Using my custom .zshrc in the dotfiles folder.."
ln -s $DOTFILES/dotzshrc /Users/vluther/.zshrc
p "Setting up .gitconfig"
ln -s $DOTFILES/gitconfig /Users/vluther/.gitconfig
#p "Setting up Zsh theme"
#ln -s $DOTFILES/oh-my-zsh/themes/vidluther.zsh-theme $HOME/.oh-my-zsh/themes/vidluther.zsh-theme

p "Going to install Homebrew"
#install_brew
p "done"

