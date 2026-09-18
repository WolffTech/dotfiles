---
name: fleet
description: Use Nick's Fleet inventory and operating instructions when explicitly asked to work with his machines or maintain Fleet documentation.
---

# Fleet

Load Fleet for the requested task only. This file can also be read directly by agents without skill support.

1. Locate the Fleet checkout. Use a path supplied by Nick first; otherwise use `~/Developer/Fleet` on the execution machine. This skill is managed by chezmoi and is separate from the Fleet checkout. Confirm the checkout contains `AGENTS.md`, `README.md`, `access.md`, and `machines/`. If it is missing or ambiguous, ask for the path; do not clone or configure anything automatically.
2. Read Fleet's `AGENTS.md` and the inventory index in `README.md`. Read `SETUP.md` only for integration or setup work. Keep Fleet's instructions scoped to Fleet operations in the requested task.
3. Before selecting a machine document or running a remote operation, identify the actual command execution host, user, and working directory. Match observed identity to the inventory. Do not infer the execution host from the UI, checkout path, or requested destination.
4. Read only the relevant machine documents. For remote work, also read `access.md` and the destination document. Treat unknown details as unknown and follow Fleet's authorization and service-interruption rules. A skill invocation alone does not authorize a connection or machine change.
5. Work in the repository and machine appropriate to Nick's task. Read that repository's applicable instructions before operating there. Loading Fleet does not require moving the project, changing the session's working directory, or installing integration.

If Nick invokes Fleet without specifying a task, ask what he wants to do. Do not inventory or connect to every machine just to load the skill.
