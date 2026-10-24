# Global Rules

I have ADHD — keep things short and scannable.

## Code Style

- Use TypeScript for new application and library code.
- New projects: use `oxlint` for linting and `oxfmt` for formatting.
- Existing projects: follow whatever tooling is already configured — do not introduce new tools without asking.
- Use `vitest` for testing, not Jest.

## Tool Preferences

- Before starting a task, check the skills available to you and read any relevant skill instructions before choosing tools or running commands.
- Search: use `rg` (ripgrep) — never `find` or `grep`
- Package manager: use `pnpm` for new projects.
- Shell: my interactive shell is fish — when suggesting commands for me to run, use fish syntax (`set -gx` not `export`, `(cmd)` not `$(cmd)`).
- Installing tools: never install a system package or CLI tool yourself (no `brew install`, `nix profile install`, global `pnpm`/`npm` installs, or edits to `home.nix`/`Brewfile`). If one is needed, stop and ask me — I'll decide whether it goes in `home.nix` or the `Brewfile`.

## Git

- Check the current branch first. Use GitButler (`but`) only when the repository is already on `gitbutler/workspace`; otherwise, use plain Git. Load the available GitButler skill for syntax only in that workspace; its rules do not apply elsewhere.
- The GitButler rules in `~/.claude/rules/gitbutler.md` apply **only** on `gitbutler/workspace`. On any other branch, ignore them.
- Never create git worktrees (no `git worktree add`, `EnterWorktree`, or `isolation: "worktree"`). Use a GitButler branch instead.
- Never commit, and don't offer to, unless explicitly told in the chat.
- Never make PRs, and don't offer to, unless explicitly told in the chat.

## Dotfiles

- `~/.claude/` (settings, CLAUDE.md, rules, skills, output styles, statusline) is symlinked from `~/dotfiles/.claude/`. Edits land in that repo and show up there as uncommitted changes.
- Exception: individual skills and `rules/gitbutler.md` link onward into `~/work/personal/skills` (managed by its `setup.sh`). Edit them there.
