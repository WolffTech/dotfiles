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

## Subagents

- When subagents would materially improve speed or quality, briefly explain the benefit and suggest their use.
- Wait for my explicit request before delegating.
- Once I request delegation, use available subagent tools without asking for confirmation again.

## Commands for me to run

- Run commands yourself when you can. Hand them to me only when you can't, such as when they need sudo, interactive login, a GUI, or access you don't have.
- Write commands for the shell on the machine where they will run: usually zsh on macOS and Linux, bash on some Linux machines, and PowerShell on Windows. Check the environment rather than assuming. If the target machine isn't the one you're running on, say which machine and shell the commands are for.
- Tag each code block with that shell (`zsh`, `bash`, or `powershell`).
- Put each step in its own code block, in the order I should run them. Each block should be safe to run as-is with one click.
- Include only commands in these blocks: no prompts like `$` or `PS>`, and no sample output. Show expected output in a separate `text` block.
- Use absolute paths or start with a `cd` when the working directory matters.
- If I need to fill in a value, say so before the block and name the placeholder clearly.

## Questions are read-only

- Treat informational and feasibility questions as requests for answers only. This includes questions such as "How do I", "How hard would it be", "What are your thoughts", "Why does", "Should we", "Is it possible", and "Can we do".
- Do not make changes unless the message explicitly asks you to act.
- A direct action request phrased as a question, such as "Can you update this file?", authorizes only the named change.
- If a question reveals an obvious or trivial change, answer first and offer to make it.

## Git branches

- Do not rename, recreate, or switch the current branch unless I ask.
- In T3 Code worktrees (`~/.t3/worktrees/`), T3 manages the branch name, and it may briefly be a placeholder like `t3code/<hex>`. Leave it as is.

## Safety and restrictions

- Ask before destructive or externally visible actions that the user did not explicitly request.
- Never touch production systems, live databases, or build and preview channels used for daily work unless explicitly instructed.
- When a task is adjacent to one of those systems, state exactly what you are about to access before accessing it.
- Do not run `az` or `aws` unless the current request gives explicit permission.
- Permission to use `az` or `aws` permits read-only commands only. Mutating commands require a separate, explicit instruction naming the intended change.
- If the scope or safety of a cloud operation is unclear, stop and explain the uncertainty before continuing.
