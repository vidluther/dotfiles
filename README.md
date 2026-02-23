# Dotfiles

#### Clone this repo
```
git clone https://github.com/vidluther/dotfiles.git ~/dotfiles
```
#### Install Nix
```
curl -L https://nixos.org/nix/install | sh

```
#### Install nix-home-manager 
```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```
#### Install homebrew 
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
#### Install packages from Brewfile 
```
cd dotfiles/
brew bundle install --verbose
stow --dotfiles . 
home-manager build
home-manager switch
sudo sh -c 'echo $(which fish) >> /etc/shells'
chsh -s $(which fish)
```
#### Open a new terminal to make sure all is well.

#### Keeping Things Up to Date
```
nix-channel --update
home-manager build
home-manager switch

brew update
brew upgrade
```

```
fnm install --lts
gh auth login
```

