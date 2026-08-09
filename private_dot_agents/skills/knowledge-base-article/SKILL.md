---
name: knowledge-base-article
description: Use when creating or revising a support or operations knowledge base article.
---

# Knowledge Base Article

Write only knowledge base articles. Do not write runbooks, SOPs, pull requests, tickets, or general documentation unless the user explicitly changes the task.

## Workflow

1. Determine whether the user is creating a new article or revising an existing file.
2. Write the full first draft or revision immediately from the information provided without asking clarifying questions first.
3. Make reasonable assumptions for low-risk details, but do not invent technical steps, permissions, safety requirements, or confirmed outcomes.
4. Mark missing, tenant-specific, or uncertain details with `TODO:` so they can be revised later.
5. For a new article, write a new `.md` file in the current working directory. For a revision, edit the identified article in place unless the user requests a new copy.
6. After writing the file, respond briefly with the filename that was created or revised.
7. Continue refining the article based on follow-up instructions.

## Writing Standard

- Write for someone who has never followed the process before.
- Prefer explicit, step-by-step instructions over shorthand.
- Use simple, direct language.
- Name admin centers, portals, tools, and products clearly before relying on abbreviations.
- Keep the article practical first and explanatory second.
- Place warnings and notes near the relevant steps when possible.
- Use bold text only for genuinely important details that need emphasis.

## Required Article Format

Use this structure for every article:

```markdown
# Title of the Article

Provide a brief description of what the article covers. Keep it to a few sentences at most when needed.

## Before you Start...

Provide important information someone should know before working the ticket.

WARNING: Things of high importance that must be read.

NOTE: Things that are relevant and should be taken into account.

TODO: Things that need to be edited in the article later. Ideally these should not remain in a published article.

## Ticket Handling

Put the main handling instructions here.

### Use Header 3 to divide sections when work happens in different environments, admin centers, or phases.

#### Use Header 4 only when it helps divide those sections further.

1. Instruction 1
2. Instruction 2
3. Instruction 3

## Extra Information

Provide practical extra information that can help with the ticket, including common issues or troubleshooting notes.

## Extensive Breakdown

Provide deeper context, background knowledge, or external references that help build team understanding.

## Related Articles

Link related articles here when needed. If none are known, leave a placeholder the user can update later.
```

## Output Rules

- Always write the article to a `.md` file instead of returning the full article in chat. Create new articles in the current working directory and revise an explicitly identified article in place.
- Choose a sensible kebab-case filename based on the article title.
- For new articles, add a numeric suffix if the chosen filename already exists. Do not use a suffix when revising an existing article.
- Do not return the full article in chat unless the user explicitly asks for it.
- Include `## Before you Start...` only when it adds meaningful prerequisites, warnings, notes, or setup context.
- Keep `## Ticket Handling` as the main procedural section.
- Use unordered lists when a checklist is clearer and ordered lists when sequence matters.
- Use `###` and `####` headings to separate work across systems or phases.
- Use `WARNING:` for must-read risk or high-impact information.
- Use `NOTE:` for relevant caveats or context.
- Use `TODO:` only for missing details or placeholders that should be resolved before publication.
- If the user provides only a rough ticket summary, still draft the full article and place targeted `TODO:` markers where exact details are unknown.
