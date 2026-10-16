# Setup and Maintenance

For an overview of the tools and configuration, see [README.md](README.md). For daily shortcuts and terminal workflows, see [WORKFLOW.md](WORKFLOW.md).

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

```fish
/bin/bash -c (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | string collect)
```

### 5. Install packages and configure shell

Home Manager has already been applied in step 3. This step installs the Homebrew-managed apps, symlinks the tracked dotfiles into `$HOME`, and switches the login shell to fish.

```fish
cd ~/dotfiles
brew bundle install --verbose
stow .
sudo sh -c 'echo $(which fish) >> /etc/shells'
chsh -s (command -v fish)
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

### 8. Enable the Herdr workflow

Install [Herdr](https://herdr.dev/docs/install/) using your preferred package manager. Herdr is not currently declared in this repo's Brewfile or Home Manager configuration. Install your chosen agent CLIs separately as needed.

The chooser plugins require `fzf` (Brewfile), `jq` (Home Manager), and `curl`. The URL chooser uses macOS `open` and `pbcopy`; the Claude hook uses `python3`. Check these are available in the environment that launches Herdr:

```fish
command -v herdr fzf jq curl python3
herdr plugin link ~/.config/herdr/plugins/local/agent-chooser
herdr plugin link ~/.config/herdr/plugins/local/url-chooser
```

Herdr plugin registration is local machine state; Stow links the plugin source, but does not register it. Run the link commands once per account.

The repo includes Herdr's OpenCode TUI integration and Claude session hook. To install or refresh the complete integrations after installing the agent CLIs:

```fish
herdr integration install opencode
herdr integration install claude
herdr integration status
```

Herdr manages the generated integration files and may rewrite their registrations, including the Claude hook path. Review resulting dotfile changes after upgrades. Restart affected agent TUIs after integration updates; see [Herdr's integration guide](https://herdr.dev/docs/integrations/) for shared-server requirements.

Enable Karabiner-Elements and select the profile that maps Caps Lock to Command+Control+Option+Shift (Hyper). Ghostty maps Hyper+O/U to the chooser shortcuts. These shortcuts are described in [WORKFLOW.md](WORKFLOW.md).

Reload Ghostty with **Cmd+Shift+,** and Herdr with **Ctrl+B**, then **Shift+R**. Padding changes in Ghostty apply to newly opened windows/tabs.

---

## Second macOS Account on the Same Mac

Nix (multi-user daemon) and Homebrew are machine-wide — **do not reinstall either**. The flake's portable `current` configuration reads the invoking login's `USER`/`HOME` (`--impure` is required for that lookup), so no second username is stored in the repository.

From a fresh fish shell in the new login:

```fish
# One-time bootstrap: the Nix installer only hooks bash/zsh, so a new
# fish login has no nix on PATH until home-manager has run once.
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
set -gx NIX_CONFIG "experimental-features = nix-command flakes"

git clone https://github.com/vidluther/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix run home-manager/master -- switch --impure --flake .#current
stow .
```

After the switch, new fish shells source `nix-daemon.fish` from the generated config, so the bootstrap lines are never needed again.

Notes:

- **Homebrew**: `/opt/homebrew/bin` binaries are shared and usable, but don't run `brew bundle`/`brew install` from the secondary account — the Homebrew prefix is owned by the primary admin user.
- **Login shell**: `/opt/homebrew/bin/fish` is already in `/etc/shells` and works fine. Using `~/.nix-profile/bin/fish` instead requires appending that per-user path to `/etc/shells` with sudo — optional.
- **stow conflicts**: if the account already has real files where symlinks should go (e.g. `~/.claude/settings.json`), move them aside and re-run `stow .` — avoid `--adopt`, it overwrites the repo copy.
- **Dry run first**: `stow --simulate --verbose .` lists proposed links and conflicts. Compare existing files before moving them aside. The local `.codex/config.toml` may differ from the tracked copy; reconcile it before a full Stow run. The Nix `result` link is excluded by `.stowrc`.
- **Claude Code settings symlink**: Claude Code < ~2.1.28x saved `~/.claude/settings.json` via temp-file + rename onto the link path, replacing the symlink with a regular file. 2.1.283+ resolves the link and writes through to the repo copy, so the link holds. If it ever turns into a regular file again, diff it against the repo copy, merge, then `mv` it aside and re-link. Note that when the cwd is `~/dotfiles`, the repo's `.claude/settings.json` is also loaded as *project* settings — harmless while the link is intact, confusing if the two copies drift.
- **1Password**: the desktop app's Settings → Developer → "Use the SSH agent" toggle is per-login — enable it once in the new session (see Gotchas below).
- **Updating later**: `home-manager switch --impure --flake ~/dotfiles#current`.

---

## Git Authentication & Commit Signing

_As of 2026-07-14, git config is fully managed by Home Manager (`programs.git` in `.config/home-manager/home.nix` → `~/.config/git/config`). There is no stow-managed git config anymore._

How it fits together:

- **SSH auth**: all SSH keys live in 1Password; `~/.ssh/config` points every host at the 1Password agent socket. Nothing expires.
- **Commit signing**: SSH signing via 1Password's `op-ssh-sign` with an ed25519 key. Commits *and* tags are signed (`commit.gpgsign`, `tag.gpgsign`), and `~/.ssh/allowed_signers` is managed by Home Manager so `git log --show-signature` / `git verify-commit` work locally. The public key is registered on GitHub as a signing key, so commits show **Verified**.
- **https auth**: `gh` is the git credential helper for `github.com` (`gh auth git-credential`), so private repos cloned over https authenticate with gh's keyring token — no PATs in the macOS keychain. `gh auth login` is the only token setup step.
- **Tokens for tools**: interactive fish shells export `GH_TOKEN`/`GITHUB_TOKEN` from `gh auth token`, so CLI tools always see a fresh token.
- **Commit email** is intentionally `vidluther@users.noreply.github.com` (GitHub email privacy).
- **Global ignores** belong in `programs.git.ignores` in `.config/home-manager/home.nix`. Home Manager generates `~/.config/git/ignore`; Stow excludes `.config/git` to avoid conflicting ownership.

### Switching an https-cloned repo to SSH

Prefer SSH remotes — they ride the 1Password agent and never hit token/OAuth problems. `gh repo clone` already clones over SSH (`git_protocol: ssh`); for a repo that was cloned over https:

```sh
cd /path/to/repo
git remote -v                                              # see the current https URL
git remote set-url origin git@github.com:<owner>/<repo>.git
```

Example:

```sh
git remote set-url origin git@github.com:vidluther/skills.git
```

### Gotchas

- **`~/.gitconfig` is unmanaged and wins.** Git reads it *after* the Home Manager config, so anything there overrides the dotfiles. GitButler stores its runtime settings in it — that's fine — but if git identity/signing ever drifts, check that no `[user]` or `[commit]` section has crept back into `~/.gitconfig`.
- **GUI apps don't inherit any of this.** GitKraken etc. never see fish env vars or git credential helpers; they need their own GitHub login (with org access granted) — or SSH remotes plus their "use local SSH agent" setting.
- **Fresh machine**: the 1Password *desktop app* provides both the SSH agent socket and `op-ssh-sign` (the Brewfile's `1password-cli` alone is not enough), and its Settings → Developer → "Use the SSH agent" toggle must be enabled once per machine. The agent socket path (`~/Library/Group Containers/2BUA8C4S2C.com.1password/...`) is 1Password's Apple Team ID — identical on every Mac, nothing machine-specific to edit.

---

## Keeping Things Up to Date

### Nix & Home Manager

Updates are driven by `flake.lock`. Bump the inputs, re-apply, and commit the new lockfile:

```sh
cd ~/dotfiles
nix flake update                       # update every input
# or: nix flake update home-manager    # update a single input
home-manager switch --flake .#vluther
```

Review and commit the lockfile update using the repository's version-control workflow (GitButler on `gitbutler/workspace`, Git elsewhere).

To roll back, restore the intended `flake.lock` through version control, then apply it:

```sh
cd ~/dotfiles
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
