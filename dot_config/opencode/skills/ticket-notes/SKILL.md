---
name: ticket-notes
description: Use when the user asks to create ticket notes, work notes, investigation notes, or a ticket resolution note from the current conversation.
---

# Ticket Notes

Create concise, paste-ready ticket notes from the work discussed in the current conversation.

## Workflow

1. Review the full conversation for investigation steps, tests, changes, observations, and findings.
2. Include the issue that was identified and the evidence supporting it.
3. If the issue is not confirmed, state the suspected cause and clearly label it as suspected or unconfirmed.
4. Include unresolved questions or next steps only when they were discussed or directly follow from an incomplete investigation.
5. Return the notes directly in the response without asking clarifying questions first.

## Resolution Notes

When the user asks for a ticket resolution note:

- Write a short paragraph of two to four sentences instead of a list.
- Briefly explain the issue and how it was resolved.
- Include the cause only when it is known and relevant.
- Omit the detailed investigation history unless the user requests it.
- If a resolution was not established, state that clearly rather than inventing one.

## Output Rules

- Use a flat bulleted list for standard ticket notes.
- Keep the notes in chronological order when practical.
- Start each item with a clear action or finding.
- Combine closely related actions and results into one item.
- Include relevant systems, commands, errors, and outcomes when available.
- Distinguish confirmed facts from assumptions or suspected causes.
- Do not invent actions, results, dates, ticket numbers, or technical details.
- Do not include a title, introduction, conclusion, or unrelated conversation details unless the user requests them.
