# Global Rules


I have ADHD. Be extremely concise in your responses.

## Code Style

- Use TypeScript for all new code.
- New projects: use `oxlint` for linting and `oxfmt` for formatting.
- Existing projects: follow whatever tooling is already configured — do not introduce new tools without asking.
- Use `vitest` for testing, not Jest.

## Tool Preferences

- Search: use `rg` (ripgrep) — never `find` or `grep`
- Package manager: use `pnpm` — never `npm`, `yarn`, or `bun`
- Git: if the current branch is `gitbutler/workspace`, use `but` (GitButler CLI) for branch and commit operations; otherwise use plain `git`
- Shell: my interactive shell is fish — when suggesting commands for me to run, use fish syntax (`set -gx` not `export`, `(cmd)` not `$(cmd)`).
- Prisma: never run migrations yourself — give me the command to run instead.

## Version Control

- Never commit, and don't offer to, unless explicitly told in the chat.
- Never make PRs, and don't offer to, unless explicitly told in the chat.
- Do not add a `Co-Authored-By` trailer to commit messages.
