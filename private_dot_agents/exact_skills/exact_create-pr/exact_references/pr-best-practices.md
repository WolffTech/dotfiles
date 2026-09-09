# Pull Request Drafting Guidance

Read this reference only when the repository has no usable pull request template or the user requests a more detailed description.

## Select Relevant Content

### Feature

- Explain the user or operator need.
- Describe the resulting behavior and important design choices.
- Note feature flags, rollout steps, compatibility, and documentation when applicable.

### Bug Fix

- Describe the observed failure and user impact.
- State the confirmed root cause when known; label suspected causes clearly.
- Explain why the change addresses the cause.
- Include regression tests or manual reproduction evidence when available.

### Refactor

- Explain why the restructuring is useful now.
- State which observable behavior remains unchanged.
- Describe the evidence used to guard against regressions.

### Documentation or Maintenance

- State what became inaccurate, obsolete, or difficult to maintain.
- Summarize the correction or maintenance outcome.
- Avoid implying runtime behavior changed when it did not.

## Writing Rules

- Tell one coherent story about the branch diff.
- Prefer specific behavior over a file-by-file inventory.
- Use present tense and concise bullets.
- Explain non-obvious decisions and meaningful tradeoffs.
- Include links and issue-closing syntax only when verified.
- Never mark a checkbox complete without evidence.
- Say `Not run` and explain why when relevant tests were not executed.
- Omit empty sections, placeholders, and generic boilerplate.

## Review Readiness

Before creation, confirm that:

- The title and body describe only commits included in the pull request.
- The target repository, base, head repository, and head branch are correct.
- The requested ready or draft status is correct.
- Uncommitted work is not described as included.
- Breaking changes and migration requirements are explicit.
- Test claims match actual output.
- No credentials, internal-only data, or unrelated changes appear in the diff or description.
