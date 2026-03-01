See the @README.md to learn more about the project's code styles and tool preferences. If none exists, don't spend too much time looking for it. 
## Code Styles
- Use TypeScript instead of JavaScript for new projects. 
- For new projects, use oxfmt and oxlint. For existing projects, follow whatever is already configured. 
  - Always run the project's formatter before committing code. 
- Use vitest instead of Jest for testing.

## Tool Preferences

- Use `rg` (ripgrep) for searching file contents and finding files, not `find` or `grep`
- Use `pnpm` instead of `npm`, `yarn`, or `bun` for package management


## Workflow
- Before committing changes, ensure there is a corresponding issue (GitHub, Linear, or whatever the project uses)
- If you can't tell what the project uses, ask the user about a specific issue ID. 
- Reference the issue ID in commit messages
- Reference the issue ID in the branch name
