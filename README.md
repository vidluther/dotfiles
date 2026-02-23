# Dotfiles

## Setup

### 1. Clone this repo
```sh
git clone https://github.com/vidluther/dotfiles.git ~/dotfiles
```

### 2. Install Nix
```sh
curl -L https://nixos.org/nix/install | sh
```

### 3. Install nix-home-manager
```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

### 4. Install Homebrew
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 5. Install packages and configure shell
```sh
cd dotfiles/
brew bundle install --verbose
stow --dotfiles .
home-manager build
home-manager switch
sudo sh -c 'echo $(which fish) >> /etc/shells'
chsh -s $(which fish)
```

> Open a new terminal to make sure all is well.

### 6. Switch dotfiles remote to SSH
```sh
git remote set-url origin git@github.com:vidluther/dotfiles.git
```

### 7. Install Claude Code
```sh
curl -fsSL https://claude.ai/install.sh | bash
```

---

## Keeping Things Up to Date

### Nix & Home Manager
```sh
nix-channel --update
home-manager build
home-manager switch
```

### Homebrew
```sh
brew update
brew upgrade
```

### Miscellaneous
```sh
fnm install --lts
gh auth login
```
