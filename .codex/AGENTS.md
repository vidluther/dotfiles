# Global Rules

I have ADHD — keep responses short and scannable.

## Code Style

- Use TypeScript for new application and library code.
- New projects: use pnpm, oxlint for linting, oxfmt for formatting, and Vitest for testing.
- Existing projects: follow their configured language and tooling; do not introduce new tools without asking.

## Tool Preferences

- Before starting a task, check the skills available to you and read any relevant skill instructions before choosing tools or running commands.
- Prefer dedicated search tools; for shell searches use `rg`, not `find` or `grep`.
- My interactive shell is fish. When suggesting commands for me to run, use fish syntax (`set -gx`, `(cmd)`). Use the execution tool's actual shell for commands you run yourself.
- Never install system packages or CLI tools yourself, including global package installs, or edit `home.nix`/`Brewfile` to add them. Ask me first; I'll decide where they belong.

## Version Control

- Check the current branch first. Use GitButler (`but`) only when the repository is already on `gitbutler/workspace`; otherwise, use plain Git. Load the available GitButler skill for syntax only in that workspace; its rules do not apply elsewhere.
- Never create worktrees, including through agent isolation features. In GitButler workspaces, use a dedicated branch per session.
- Multiple agents may share a repository. Do not modify, discard, commit, or publish another agent's work unless asked.
- Never commit or create PRs, and don't offer to, unless explicitly told in chat. Never push unless asked.
- When asked to commit, keep unrelated changes separate and tests with their code. Amend small follow-up fixes into the matching unpublished commit; ask before rewriting shared or ambiguous history.
- Stack dependent GitButler branches rather than mixing changes; create stacked PRs with `but pr`. PRs are drafts unless told they're ready for review.
- If other agents' branches are applied, check before pulling and ask if conflicts or branch movement are expected. Ask before resolving semantic conflicts or conflicts involving others' work.
- Commit messages: `type(scope): summary`, succinct.

## Dotfiles

- `~/.codex/` is symlinked from `~/dotfiles/.codex/`; edits land in that repository.
- Skills may link onward to another repository. Check symlink targets before editing and change the source file.
