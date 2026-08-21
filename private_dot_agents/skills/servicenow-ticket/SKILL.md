---
name: servicenow-ticket
description: Use when drafting or revising a ServiceNow change request, incident, or service request.
---

# ServiceNow Ticket

Draft tickets that are ready to copy and paste into ServiceNow fields.

## Workflow

1. Identify the ticket type from the request and current context.
2. Draft every applicable field using only information available in the current context, without asking clarifying questions first.
3. When the context does not support a detail, omit it. Do not add placeholders, assumptions, likely configuration, or routine steps that were not provided.
4. Edit for density. Remove repetition, generic explanation, speculative risks, and procedural detail that does not help someone perform or review the work.
5. Present the ticket fields.

## Change request

Before drafting a change request, read [the synthetic change request example](references/change-request-example.md). Match its structure and information density. Use it only as a writing model.

SHORT DESCRIPTION
[One sentence naming the change and its primary target]

DESCRIPTION
[Scope and important configuration; use a compact list when several settings belong together]

JUSTIFICATION
[One short paragraph explaining the business purpose and relevant controls]

IMPLEMENTATION PLAN
[Ordered actions; place parameters beneath the action where they are used]

RISK AND IMPACT ANALYSIS
[Credible change-specific risks with likelihood and mitigation, followed by the expected impact]

BACKOUT PLAN
[Ordered actions that reverse the implementation and remove created resources or configuration]

COMMUNICATION PLAN
[Notify stakeholders when implementation begins and when it finishes; include validation or backout results]

POST TEST PLAN
[Observable checks that confirm each intended result]

## Incident

TITLE
[Brief description of what is broken or degraded]

DESCRIPTION
[Symptoms, affected systems, timeline, and known context]

## Service request

TITLE
[What is being requested]

ADDITIONAL DETAILS
[Context, requirements, and constraints; use prose unless a list is easier to scan]

## Writing standard

- Write a compact operational record. Every sentence or list item must provide a ticket-specific fact, action, risk, mitigation, backout action, or test.
- Keep narrative fields to one short paragraph unless structured facts are clearer as a list.
- State configuration once unless someone needs it again to perform or validate the work.
- Use consistent terminology and neutral wording that does not refer to the writer or reader.
- When timing matters, use absolute dates and times with a time zone.

## Formatting

- Use Markdown headings for field names. The headings are not intended to be copied into ServiceNow.
- Use numbered items for ordered work, configuration, risks, and validation.
- Use hyphens for parameters or supporting details beneath a numbered item.
- Add substeps only when they contain information needed to perform the parent step.
