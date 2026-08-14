---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save it under `docs/agents/handoffs/` at the repo root - create the directory if needed (in a multi-context repo, use `docs/<context>/agents/handoffs/`). This is a tracked location, so a fresh agent can find and reference the handoff via editor autocomplete. Name the file descriptively and date-prefixed: `2026-08-03-<slug>.md`.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
