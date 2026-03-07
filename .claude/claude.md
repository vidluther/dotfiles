# Claude Rules

See @README.md for project-specific code styles and tool preferences.

## Workflow

- At the start of every session, check for `./.plan.md`.
  - If it doesn't exist, ask what I want to work on and create it before proceeding.
  - If it exists, read it fully and summarize the current state back to me before doing anything.
- Lines starting with `%%` are my annotations — use them to revise the plan, then remove them after incorporating.
- Task status markers:
  - `[ ]` = not started
  - `[~]` = in progress
  - `[x]` = complete
  - `[!]` = blocked — note the reason inline
- Update task status in `plan.md` as you complete work. Do not wait until the end.
- Never start implementing until the plan is written and I have confirmed it.
- If an issue ID is referenced in `plan.md`, use it in all branch names and commit messages.
  - Branch format: `issue-{id}/short-description`
  - Commit format: `[{id}] short description`

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

## Session Continuity

- `.plan.md` is the handoff record between sessions — treat it as the source of truth, not the chat history.
- If state looks stale or ambiguous on session start, ask before assuming.
- Run `/exit` at the end of each session to trigger the wrap-up ritual.
