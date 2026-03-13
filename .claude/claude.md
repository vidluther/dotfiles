# Claude Rules

## Code Style

- Use TypeScript for all new code.
- New projects: use `oxlint` for linting and `oxfmt` for formatting.
- Existing projects: follow whatever tooling is already configured — do not introduce new tools without asking.
- Run the project's formatter before every commit.
- Use `vitest` for testing, not Jest.

## Tool Preferences

- Search: use `rg` (ripgrep) — never `find` or `grep`
- Package manager: use `pnpm` — never `npm`, `yarn`, or `bun`
- Git: use `but` (GitButler CLI) for branch and commit operations
