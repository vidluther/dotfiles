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

### 3. Bootstrap Home Manager via flake

Home Manager is installed and applied in one step through the flake — no channels, no pre-install.

Flakes must be enabled. [Determinate Nix](https://determinate.systems/) turns them on by default; with the official installer, add the following to `~/.config/nix/nix.conf` first:

```
experimental-features = nix-command flakes
```

Then bootstrap:

```sh
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#vluther
```

This fetches Home Manager from GitHub, builds the `vluther` configuration defined in `flake.nix`, and activates it. After the first switch, `home-manager` is on `PATH` and future runs can use it directly. The flake pins both `nixpkgs` and `home-manager` in `flake.lock`, so builds are reproducible regardless of what `nix run` resolves to at bootstrap time.

### 4. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 5. Install packages and configure shell

Home Manager has already been applied in step 3. This step installs the Homebrew-managed apps, symlinks the tracked dotfiles into `$HOME`, and switches the login shell to fish.

```sh
cd ~/dotfiles
brew bundle install --verbose
stow .
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

Updates are driven by `flake.lock`. Bump the inputs, re-apply, and commit the new lockfile:

```sh
cd ~/dotfiles
nix flake update                       # update every input
# or: nix flake update home-manager    # update a single input
home-manager switch --flake .#vluther
git add flake.lock
but commit -m "flake: update inputs"
```

To roll back to the previously committed inputs:

```sh
cd ~/dotfiles
git checkout flake.lock
home-manager switch --flake .#vluther
```

### Homebrew

```sh
brew update
brew upgrade

```

### Keep The Brewfile Up to Date

```
cd ~/dotfiles/
brew bundle dump --force
```

### Miscellaneous

```sh
fnm install --lts
gh auth login
```
