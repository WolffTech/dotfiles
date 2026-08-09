---
name: servicenow-ticket
description: Use when drafting or revising a ServiceNow change request, incident, or service request.
---

# ServiceNow Ticket

Draft tickets that are ready to copy and paste into ServiceNow fields.

## Workflow

1. Select the requested ticket type. If it is ambiguous, draft the most likely type and state the assumption briefly.
2. Generate the complete ticket draft from the available information without asking clarifying questions first.
3. Do not invent actions, results, approvals, dates, ticket numbers, or technical details.
4. Present the full draft to the user.

## Change Request

TITLE
[Brief summary of what is being changed]

DESCRIPTION
[What is being changed and why; provide context for reviewers]

JUSTIFICATION
[Business reason this change is necessary; do not use a list]

IMPLEMENTATION PLAN
[Detailed step-by-step actions to execute the change, including pre-checks and verification steps]

RISK AND IMPACT ANALYSIS
[Potential risks, likelihood, affected systems or users, and mitigation strategies]

BACKOUT PLAN
[Steps to revert if the change fails or causes issues]

COMMUNICATION PLAN
[Email communication when the change begins and when it is complete]

POST TEST PLAN
[Validation steps to confirm the change was successful]

## Incident

TITLE
[Brief description of what is broken or degraded]

DESCRIPTION
[Symptoms, affected systems, timeline, and known context]

## Service Request

TITLE
[What is being requested]

ADDITIONAL DETAILS
[Full context for the request; use prose rather than a list]

## Writing Guidelines

- Be specific and actionable.
- Include enough detail for someone unfamiliar with the context to understand.
- Use consistent terminology.
- Use neutral wording that does not reference a person. Avoid phrases such as "I need you to", "you should", or "we're requesting".
- Avoid ambiguous relative time references such as "today" or "later." When timing matters, use absolute dates and times with a time zone.

## Formatting

- Use numbered items for top-level points when making lists.
- Use hyphens for substeps or details under each main point.
- Use tabs rather than spaces when indenting.
- Use headers for each field. The headers are not intended to be copied into ServiceNow.
