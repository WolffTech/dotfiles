---
name: conventional-commit
description: Use before running `git commit` or proposing a Git commit message, including commits made during a larger implementation workflow.
---

# Conventional Commit

Use this before running `git commit` or proposing a Git commit message.

## Workflow

1. Review repository instructions and recent commit subjects for local conventions.
2. Review the repository state with `git status`.
3. Inspect the relevant changes with `git diff` and `git diff --cached`.
4. If the user wants to commit, stage only the files included in the requested change. Do not alter unrelated staged changes.
5. Build a commit message with these parts:
   - `type`: one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
   - `scope`: optional, short subsystem or area name
   - `description`: required, short imperative summary
   - `body`: optional, bulleted list of changes made
   - `footer`: optional, breaking changes or issue references
6. If creating the commit, run `git commit` with the finalized message. If only proposing a message, return it without committing.

## Message Shape

```text
type(scope): description

- change 1
- change 2
- change 3

footer
```

Rules:
- Follow explicit repository conventions when they differ from these defaults.
- Omit `(scope)` when there is no useful scope.
- Use imperative mood, for example `add`, not `added`.
- Subject line must be 72 characters or fewer.
- Wrap all body lines at 72 characters.
- When a body is useful, format it as a bulleted list (`- `) summarizing each change in the commit.
- Each bullet should be a concise, imperative statement of what changed.
- Order bullets by importance or logical grouping.
- Put exactly one blank line between the subject and body.
- Do not put blank lines between body bullets.
- Never include literal `\n` text in a commit message.
- Use `!` or a `BREAKING CHANGE:` footer for breaking changes.

## Creating the Commit

For a subject-only message, use one `-m` argument:

```sh
git commit -m "chore: update development dependencies"
```

For a multiline message, pass the complete message through standard input:

```sh
git commit -F - <<'COMMIT_MESSAGE'
fix(ui): correct button alignment on mobile

- Set flex-wrap on button container for narrow viewports
- Add min-width to prevent button text truncation
COMMIT_MESSAGE
```

Do not use a separate `-m` argument for each bullet. Git treats each `-m`
argument as a separate paragraph and inserts blank lines between them.

## Validation

- `type` must be one of the allowed Conventional Commits types.
- `scope` is optional but should be specific when used.
- `description` is required and should describe the change, not the implementation process.
- Subject line (`type(scope): description`) must not exceed 72 characters.
- When present, `body` is a bulleted list of changes, with each line wrapped at 72 characters.
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

When creating the commit, commit only the conventional commit message. Never
include explanatory text such as `Suggested conventional commit:` in the Git
commit message.
