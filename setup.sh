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

# _dotfiles="$HOME/.zshrc
# $HOME/.gitconfig
# $HOME/bin
# $HOME/work"

# #printf "%s\n" "${_dotfiles}" | \
# #  while IFS="$(printf '\t')" read d; do
# #    p "Checking ${d}"
# #    test -f "${d}" || p "${d} does exist"
# #  done

# #p "Done"
# #exit 0; 
# ##########
# The lines above should be modified and setup to things properly.
# but the assumption/laziness here says that assume you have a clean install and 
# that there are not .zshrc, gitconfig, or bin directories already setup.

p "Setting up ~/bin"
ln -s $DOTFILES/bin /Users/vluther/bin
p "Setting up .zshrc"
ln -s $DOTFILES/dotzshrc /Users/vluther/.zshrc
p "Setting up .gitconfig"
ln -s $DOTFILES/gitconfig /Users/vluther/.gitconfig
p "Setting up Zsh theme"
ln -s $DOTFILES/oh-my-zsh/themes/vidluther.zsh-theme $HOME/.oh-my-zsh/themes/vidluther.zsh-theme

p "Going to install Homebrew"
install_brew
p "done"

