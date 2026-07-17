# Claude Rules

Be extremely concise in your responses.  

## Code Style

- Use TypeScript for all new code.
- New projects: use `oxlint` for linting and `oxfmt` for formatting.
- Existing projects: follow whatever tooling is already configured — do not introduce new tools without asking.
- Use `vitest` for testing, not Jest.

## Tool Preferences

- Search: use `rg` (ripgrep) — never `find` or `grep`
- Package manager: use `pnpm` — never `npm`, `yarn`, or `bun`
- Git: if the current branch is `gitbutler/workspace`, use `but` (GitButler CLI) for branch and commit operations; otherwise use plain `git`
- Shell: I use the fish shell, so when you ask me to run commands, remember things related to fish.
- Prisma: do not run/test migrations yourself, make sure I run them 

## Version Control

- Do not offer to make commits. Do not commit, unless explicitly told to in the chat.
- Do not offer to make PRs. Do not make PRs, unless explicitly told to in the chat.
- Do not add a `Co-Authored-By` trailer to commit messages.
