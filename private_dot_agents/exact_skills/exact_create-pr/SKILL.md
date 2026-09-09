---
name: create-pr
description: Use when composing, previewing, or creating a GitHub pull request from the current branch, including ready-for-review and GitHub draft PRs; determining the target repository, base, head, and remotes; reviewing commits and diffs; pushing the branch; or running `gh pr create`.
---

# Create Pull Request

Draft or create a pull request that accurately describes the committed changes on the current branch. Never claim that a test, check, review, or outcome occurred without evidence.

## Choose the Mode

- **Proposal only**: Return a title and body without pushing or changing GitHub state.
- **Create ready PR**: Push when needed and create a ready-for-review pull request.
- **Create GitHub draft PR**: Push when needed and create the pull request with draft status.

Interpret "draft a PR" as proposal only, "create a PR" or "open a PR" as ready PR creation, and "create a draft PR" or "open a draft PR" as remote creation with draft status. Ask one concise question only when the wording is genuinely ambiguous and the answer changes remote state.

## Workflow

1. Read repository instructions, contribution guidance, and pull request templates. Follow repository-specific requirements over this skill.
2. Inspect the local repository:
   - Confirm the worktree, current branch, remotes, and status.
   - Require a named branch before remote creation; stop on detached `HEAD`.
   - Review staged, unstaged, and untracked changes separately from committed branch changes.
   - Treat uncommitted changes as excluded from the pull request and disclose them when relevant.
3. Before querying GitHub or creating remote state, verify that `gh` is installed and authenticated.
   - Treat `gh` as the primary GitHub interface for this workflow. Do not switch to an app connector or browser merely because a sandboxed `gh` command failed.
   - In local macOS environments, assume the GitHub CLI credential may be stored in the system keyring and unavailable inside the command sandbox. Run networked `gh` commands with host/network permission when the execution tool supports it. Request reusable approval only for the narrow subcommand needed, such as `gh auth status`, `gh repo view`, `gh pr list`, `gh pr create`, or `gh pr view`; do not request a blanket approval for `gh`.
   - If a sandboxed check reports an invalid token, missing authentication, DNS or network failure, or credential-store failure, rerun the same check with host/network permission before diagnosing authentication. Only treat authentication as broken when the host-level check fails too.
   - Never display or extract the token. Do not run `gh auth login`, `gh auth refresh`, `gh auth logout`, change credential storage, or set a token environment variable without user approval.
   - Use an app connector or authenticated browser only after host-level `gh` access is genuinely unavailable or unauthenticated. Treat connector authentication as independent from GitHub CLI authentication.
   - In proposal-only mode, continue from local evidence when host-level GitHub access is unavailable and disclose that existing-PR and remote metadata were not verified. Do not install software or change authentication without user approval.
4. Resolve the pull request topology before selecting the comparison ref:
   - Honor an explicitly supplied target repository.
   - Check for an existing open pull request from the current branch before drafting or choosing a base. If one exists, report it and update it only when the user asks.
   - Distinguish the target repository and base branch from the head repository, head branch, and push remote. In fork or multi-remote workflows, do not infer one from the other or assume that `origin` is correct.
5. Determine the base branch in this order:
   - Use a base explicitly supplied by the user.
   - Reuse the base from an existing pull request for the branch.
   - Query the target repository's default branch with `gh repo view`.
   - Fall back to the target remote's HEAD symbolic reference.
   - Do not assume `main` or `master`.
6. Resolve the base to an explicit remote-tracking ref. Fetch the selected target branch before comparison when network access is available. When a local sandbox blocks network access, request host/network permission for the narrow `git fetch` command instead of treating the remote as unavailable. If fetching remains unavailable, use the existing remote-tracking ref and disclose that its freshness was not verified.
7. Validate the branch relationship:
   - Ensure the head and base are not the same repository and branch. Permit matching branch names when the repositories differ, as in fork-based pull requests.
   - Confirm that `base-ref..HEAD` contains commits and that `base-ref...HEAD` contains a non-empty diff. Stop rather than creating an empty pull request.
   - Resolve the exact writable head remote before pushing.
8. Review the committed branch changes:
   - Review commits in `base-ref..HEAD`.
   - Use the merge-base diff in `base-ref...HEAD`.
   - Start with diff statistics and changed filenames.
   - Read the relevant diff closely enough to explain behavior, motivation, risks, and testing.
   - Run relevant, reasonably scoped validation when repository instructions or the task require it. Otherwise state that tests were not run.
9. Compose the pull request:
   - Follow the repository's title convention. Otherwise use a concise imperative title; use Conventional Commit syntax only when the repository uses it.
   - Use the repository's pull request template when present.
   - Explain what changed and why.
   - Keep the title and body focused on the project. Do not mention AI, AI assistance, agents, or AI authorship unless AI functionality is itself part of the change.
   - Include only relevant sections and remove unused placeholders.
   - Distinguish tests that passed, tests that failed, and tests that were not run.
   - Mention breaking changes, rollout concerns, screenshots, and related issues only when applicable.
10. Validate every claim against the diff, commit history, test output, or user-provided context. Do not invent issue numbers, test results, reviewers, labels, or deployment details.
11. Complete the selected mode:
    - For proposal only, return the proposed title, body, target repository, base, and head without changing remote state.
    - For an explicit creation request, do not ask for another confirmation solely because pushing and PR creation change remote state. Ask only when a material choice remains unresolved, such as the target repository, base, head remote, or draft status.
    - Push `HEAD` only to the resolved head remote when necessary, setting upstream without force-pushing. When a local sandbox blocks network or credential-store access, request host/network permission for the narrow `git push` command.
    - Write the body to a temporary file, pass it with `gh pr create --body-file`, and remove the file after the command completes.
    - Pass the target repository, base, and head explicitly to `gh pr create`; include `--draft` only for GitHub draft mode.
    - Include requested draft status, reviewers, labels, or issue references in the same creation command when supported.
12. Read back the created pull request with host-level `gh` access and verify its URL, title, target repository, base, head, and draft status before reporting success.

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

- For proposal-only mode, return the proposed title, target repository, base, head, and complete body.
- For either creation mode, return the pull request URL, target repository, base, head, and draft status.
- If blocked, state the exact prerequisite or repository state that prevents creation and the next required action.
