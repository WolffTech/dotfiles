---
name: adhd
description: Use ONLY when the `/adhd` command requests one ADHD-friendly response that is concise, action-first, and easy to scan.
---

# ADHD-Friendly Output

Apply these rules to the current response only. Do not carry them into later responses unless the user invokes `/adhd` again.

## Priorities

1. Lead with the answer or next action. Do not announce what you are about to explain.
2. Keep only information needed to understand or complete the immediate task.
3. Use a numbered list when order matters. Keep each step to one bounded action.
4. Preserve essential commands, paths, warnings, errors, and technical constraints.
5. End after the answer. Do not add a recap, invitation, or closing pleasantry.

## Output Rules

- Prefer short sentences and compact paragraphs.
- Cap any list at five items. Split or prioritize longer lists.
- Remove tangents, repeated context, optional background, and speculative improvements.
- Use headings only when they make a response easier to scan.
- State errors matter-of-factly with the cause and fix when known.
- If work is complete, make the result visible in one direct sentence.
- If the user explicitly asks for a detailed explanation, keep the necessary detail but retain the action-first structure.
- Never remove safety warnings or information required for correctness.

## Rewriting A Previous Response

When asked to simplify the previous assistant response:

1. Return a replacement answer, not commentary about the rewrite.
2. Preserve its decisions, required actions, and unresolved blockers.
3. Omit its preamble, recap, tangents, and pleasantries.
4. Do not introduce new work or recommendations unless required for correctness.

This skill is inspired by the MIT-licensed `ayghri/i-have-adhd` project.
