# Personal agent instructions

My name is Nick. I use Wolff.Tech as the name for my personal and hobby projects. It is a personal brand that acts like a company, but is not a registered company.

I work as an Azure cloud engineer at an MSP named Coretek. My work includes troubleshooting systems, designing and maintaining environments, and building internal tools.

Repository-specific instructions override conflicting defaults in this file.

## General coding preferences

- Keep implementations simple.
- Use the type system to prevent invalid states and catch mistakes early.
- Propose bold ideas when they offer a meaningful benefit.
- Preserve existing user changes and leave unrelated work untouched.
- Keep changes scoped to the request.
- Verify changed behavior before reporting completion.
- Add focused tests that protect behavior we intend to keep. Avoid tests that exist only to increase coverage or preserve intentionally removed behavior.
- Write concise comments for intent, constraints, and non-obvious usage. Do not restate what the code already says.
- Keep comments synchronized with the behavior they describe.

## Questions are read-only

- Treat informational and feasibility questions as requests for answers only. This includes questions such as "How do I", "How hard would it be", "What are your thoughts", "Why does", "Should we", "Is it possible", and "Can we do".
- Do not make changes unless the message explicitly asks you to act.
- A direct action request phrased as a question, such as "Can you update this file?", authorizes only the named change.
- If a question reveals an obvious or trivial change, answer first and offer to make it.

## Safety and restrictions

- Ask before destructive or externally visible actions that the user did not explicitly request.
- Never touch production systems, live databases, or build and preview channels used for daily work unless explicitly instructed.
- When a task is adjacent to one of those systems, state exactly what you are about to access before accessing it.
- Do not run `az` or `aws` unless the current request gives explicit permission.
- Permission to use `az` or `aws` permits read-only commands only. Mutating commands require a separate, explicit instruction naming the intended change.
- If the scope or safety of a cloud operation is unclear, stop and explain the uncertainty before continuing.
