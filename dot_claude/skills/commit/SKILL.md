---
name: commit
description: Use when the user wants changes committed to git.
allowed-tools: Bash(git *)
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
   - `body`: optional, bulleted list of changes made
   - `footer`: optional, breaking changes or issue references
5. If the user asked you to create the commit, run `git commit` with the finalized message. Otherwise, return the proposed message without committing.

## Message Shape

```text
type(scope): description

- change 1
- change 2
- change 3

footer
```

Rules:
- Omit `(scope)` when there is no useful scope.
- Use imperative mood, for example `add`, not `added`.
- Subject line must be 72 characters or fewer.
- Wrap all body lines at 72 characters.
- Body is a bulleted list (`- `) summarizing each change in the commit.
- Each bullet should be a concise, imperative statement of what changed.
- Order bullets by importance or logical grouping.
- Use `!` or a `BREAKING CHANGE:` footer for breaking changes.

## Validation

- `type` must be one of the allowed Conventional Commits types.
- `scope` is optional but should be specific when used.
- `description` is required and should describe the change, not the implementation process.
- Subject line (`type(scope): description`) must not exceed 72 characters.
- `body` is a bulleted list of changes, with each line wrapped at 72 characters.
- `footer` should carry breaking change details or issue references.

Reference: `https://www.conventionalcommits.org/en/v1.0.0/#specification`

## Examples

Subject-only (for single, self-explanatory changes):
- `chore: update development dependencies`

Full message with body:

```text
feat(parser): add array literal support

- Add tokenizer rules for bracket-delimited lists
- Implement ArrayLiteral AST node with element parsing
- Support nested arrays and trailing commas
```

```text
fix(ui): correct button alignment on mobile

- Set flex-wrap on button container for narrow viewports
- Add min-width to prevent button text truncation
```

```text
feat!: require configured mail provider for registration

- Remove fallback to console logging for outbound mail
- Add startup validation for SMTP or API mail config
- Return 503 from /register when mail is unconfigured

BREAKING CHANGE: registration endpoint now requires a
configured mail provider; previously it silently dropped
confirmation emails.
```

## Output

When the user asks for a commit message, return a message in this format:

```text
Suggested conventional commit:
<final message>
```

When the user asks you to commit, use the same format for the message you execute.
