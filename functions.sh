p () {
  printf "\n\033[1m\033[34m%s\033[0m\n\n" "${1}"
}



install_brew () {
  if ! which brew > /dev/null; then
    ruby -e \
      "$(curl -Ls 'https://github.com/Homebrew/install/raw/master/install')" \
      < /dev/null > /dev/null 2>&1
  fi
  brew analytics off
  brew update
  brew doctor
  
}