---
name: conventional-commit
description: Use when the user wants changes committed to git.
---

# Conventional Commit

Use this when the user wants to commit changes to git.

## Workflow

1. Review the repository state with `git status`.
2. Inspect the relevant changes with `git diff` and `git diff --cached`.
3. If the user wants to commit, stage the intended files.
4. Build a commit message with these parts:
   - `type`: one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
   - `scope`: optional, short subsystem or area name
   - `description`: required, short imperative summary
   - `body`: optional, brief context explaining why
   - `footer`: optional, breaking changes or issue references
5. If the user asked you to create the commit, run `git commit` with the finalized message. Otherwise, return the proposed message without committing.

## Message Shape

```text
type(scope): description

body

footer
```

Rules:
- Omit `(scope)` when there is no useful scope.
- Use imperative mood, for example `add`, not `added`.
- Keep the subject concise.
- Use `!` or a `BREAKING CHANGE:` footer for breaking changes.

## Validation

- `type` must be one of the allowed Conventional Commits types.
- `scope` is optional but should be specific when used.
- `description` is required and should describe the change, not the implementation process.
- `body` should explain why the change exists when extra context helps.
- `footer` should carry breaking change details or issue references.

Reference: `https://www.conventionalcommits.org/en/v1.0.0/#specification`

## Examples

- `feat(parser): add array literal support`
- `fix(ui): correct button alignment on mobile`
- `docs: update setup instructions for opencode skills`
- `refactor(config): simplify provider selection`
- `chore: update development dependencies`
- `feat!: require configured mail provider for registration emails`

## Output

When the user asks for a commit message, return a message in this format:

```text
Suggested conventional commit:
<final message>
```

When the user asks you to commit, use the same format for the message you execute.
