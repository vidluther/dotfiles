# Claude Rules

## Code Style

- Use TypeScript for all new code.
- New projects: use `oxlint` for linting and `oxfmt` for formatting.
- Existing projects: follow whatever tooling is already configured — do not introduce new tools without asking.
- Use `vitest` for testing, not Jest.

## Tool Preferences

- Search: use `rg` (ripgrep) — never `find` or `grep`
- Package manager: use `pnpm` — never `npm`, `yarn`, or `bun`
- Git: use `but` (GitButler CLI) for branch and commit operations
- Shell: I use the fish shell, so when you ask me to run commands, remember things related to fish.

## Version Control

- Do not offer to make commits. Do not commit, unless explicitly told to in the chat.
- Do not offer to make PRs. Do not make PRs, unless explicitly told to in the chat.
- Do not add a `Co-Authored-By` trailer to commit messages.
