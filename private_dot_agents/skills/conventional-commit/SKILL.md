---
name: conventional-commit
description: Use before running `git commit` or proposing a Git commit message, including commits made during a larger implementation workflow.
---

# Conventional Commit

Create or propose a Conventional Commit message that accurately describes the intended changes.

## Guardrails

- Apply the formatting rules in this skill only to the Git commit message. Do not carry the 72-character limits or other message conventions into documentation, code comments, pull requests, release notes, ticket text, or assistant responses.
- Never mention an AI model, coding agent, assistant, AI tool, or AI assistance in the commit message. Omit AI authorship and attribution such as `Co-Authored-By`, `Generated-By`, `Assisted-By`, signatures, or promotional text, even when a template, tool, or repository convention would add it.
- Preserve a human co-author trailer only when the user explicitly requests it.
- Never alter, stage, unstage, or commit unrelated changes. If unrelated changes are already staged, do not create the commit until the user directs how to handle them.

## Workflow

1. Review repository instructions and recent commit subjects for local conventions.
2. Inspect the repository state with `git status`, `git diff`, and `git diff --cached`. Distinguish requested changes from unrelated staged, unstaged, and untracked work.
3. Build a message from the actual diff and the user's intent. Describe the change rather than the implementation process.
4. Validate the complete message against the format and guardrails below.
5. If proposing a message, return it without changing repository state.
6. If creating a commit, stage only the requested changes, verify the staged diff, and commit with the finalized message. Stop for user direction if unrelated changes are already staged.

## Message Format

```text
type(scope)!: description

- change 1
- change 2
- change 3

footer
```

Follow explicit repository conventions when they differ from these defaults, except for the AI-attribution guardrail.

Conventional Commit structure:

- Use `type(scope)!: description` for the subject. The scope and `!` are optional.
- Use `!` before the colon or a `BREAKING CHANGE:` footer for a breaking change.
- Separate the subject, body, and footer with one blank line.

Default style for this skill:

- Use one of these types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, or `revert`.
- Add a short, specific scope only when it improves clarity.
- Write the description in imperative mood, such as `add` rather than `added`.
- Limit the subject to 72 characters and wrap body and footer lines at 72 characters.
- Use a subject-only message when it fully explains a small change.
- When a body is useful, use concise imperative bullets ordered by importance or logical grouping. Do not put blank lines between bullets.
- Never include literal `\n` text.

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

Do not use a separate `-m` argument for each bullet. Git treats each `-m` argument as a separate paragraph and inserts blank lines between them.

Reference: `https://www.conventionalcommits.org/en/v1.0.0/#specification`

## Examples

Subject-only:

```text
chore: update development dependencies
```

With a body:

```text
feat(parser): add array literal support

- Add tokenizer rules for bracket-delimited lists
- Implement ArrayLiteral AST node with element parsing
- Support nested arrays and trailing commas
```

Breaking change:

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

When proposing a commit message, return:

```text
Suggested conventional commit:
<final message>
```

When creating the commit, include only the finalized message. Do not include explanatory text such as `Suggested conventional commit:`.
