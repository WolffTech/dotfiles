---
name: create-pr
description: Use when drafting or creating a GitHub pull request from the current branch, including determining the base branch, reviewing commits and diffs, composing the title and body, pushing the branch, or running `gh pr create`.
---

# Create Pull Request

Draft or create a pull request that accurately describes the committed changes on the current branch. Never claim that a test, check, review, or outcome occurred without evidence.

## Workflow

1. Determine whether the user wants only a draft or wants the branch pushed and the pull request created.
2. Read repository instructions, contribution guidance, and pull request templates. Follow repository-specific requirements over this skill.
3. Inspect the repository state:
   - Confirm the current branch and remotes.
   - Review staged, unstaged, and untracked changes separately from committed branch changes.
   - For remote creation, verify that `gh` is installed and authenticated. Do not install software or change authentication without user approval.
4. Determine the base branch in this order:
   - Use a base explicitly supplied by the user.
   - Reuse the base from an existing pull request for the branch.
   - Query the repository's default branch with `gh repo view`.
   - Fall back to the remote HEAD symbolic reference.
   - Do not assume `main` or `master`.
5. Compare the branch against the selected base using the merge-base diff:
   - Review commits in `base..HEAD`.
   - Start with diff statistics and changed filenames.
   - Read the relevant diff closely enough to explain behavior, motivation, risks, and testing.
   - Treat uncommitted changes as excluded from the pull request and disclose them when relevant.
6. Check whether a pull request already exists for the branch. If one exists, report it and update it only when the user asks.
7. Compose the pull request:
   - Follow the repository's title convention. Otherwise use a concise imperative Conventional Commit-style title.
   - Use the repository's pull request template when present.
   - Explain what changed and why.
   - Include only relevant sections and remove unused placeholders.
   - Distinguish tests that passed, tests that failed, and tests that were not run.
   - Mention breaking changes, rollout concerns, screenshots, and related issues only when applicable.
8. Validate every claim against the diff, commit history, test output, or user-provided context. Do not invent issue numbers, test results, reviewers, labels, or deployment details.
9. Before changing remote state, show the proposed title, body, base, and head. Ask for confirmation unless the user already approved those exact details or explicitly requested immediate creation.
10. When creation is approved:
    - Push the current branch to the appropriate remote if necessary, setting upstream without force-pushing.
    - Write the body to a temporary file and pass it with `gh pr create --body-file` to preserve multiline formatting.
    - Include requested draft status, reviewers, labels, or issue references in the same creation command when supported.
11. Read back the created pull request and report its URL, title, base, head, and draft status.

## Suggested Body

Use this only when the repository does not provide a template. Omit sections that add no value.

```markdown
## Summary

[What changed and why]

## Changes

- [Specific change]
- [Specific change]

## Testing

- [Command or manual check and its result]

## Risks

- [Risk, breaking change, rollout note, or `None identified`]
```

For change-type-specific drafting guidance, read `references/pr-best-practices.md` only when the repository has no usable template or the user asks for a more detailed description.

## Output

- For a draft request, return the proposed title, base branch, and complete body without pushing or creating anything.
- For a creation request, return the pull request URL and a concise summary of what was created.
- If blocked, state the exact prerequisite or repository state that prevents creation and the next required action.
