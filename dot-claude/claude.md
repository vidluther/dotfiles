See the @README.md to learn more about the project's code styles and tool preferences.

## Workflow

- Always check for a ./plan.md file , if it doesn't exist Ask Me what I plan to work on.
- Review the ./plan.md for lines that start with %%, these are my annotations to you, use them to revise the plan.
- Rewrite the ./plan.md before implementing any tasks.
- If there is an issue id referenced in the ./plan.md reference it for commits and branch names.

## Code Styles

- Use TypeScript instead of JavaScript for new projects.
- For new projects, use oxfmt and oxlint. For existing projects, follow whatever is already configured.
  - Always run the project's formatter before committing code.
- Use vitest instead of Jest for testing.

## Tool Preferences

- Use `rg` (ripgrep) for searching file contents and finding files, not `find` or `grep`
- Use `pnpm` instead of `npm`, `yarn`, or `bun` for package management
