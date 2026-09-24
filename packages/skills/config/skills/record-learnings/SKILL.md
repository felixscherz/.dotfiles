---
name: record-learnings
description: Capture a realization, insight, correction, or improved understanding into the right durable place (a CLAUDE.md/AGENTS.md, an existing skill, project docs, or memory) instead of letting it evaporate. Use when the user says "record this", "remember this", "capture this learning", "I realized ...", "note this for next time", or "this should go in CLAUDE.md". Distinguishes project-level learnings (the default) from global learnings that apply across all repos.
---

# Record Learnings

Turn a fresh realization into a durable, discoverable note in the correct file,
so a future agent or the user benefits automatically without re-deriving it.

## The core distinction: project vs global

Decide scope first; it determines where the learning lives.

- **Project-level (the default, most of the time)** - anything tied to *this*
  codebase, deployment, or domain: architecture quirks, gotchas, conventions,
  commands, config, service topology, "we tried X and it failed because Y."
- **Global** - knowledge that helps *regardless of which repo you are in*: the
  user's cross-cutting workflow preferences, tooling habits, or general
  technical facts they want applied everywhere.

Litmus test: **"Would this note help an agent working in a completely unrelated
repo?"** If no, project. If unsure, project. Only go global when it clearly
generalizes, and prefer to **ask the user** before writing anything global,
since global notes affect every future session.

## Process

1. **Restate the learning** in one or two sentences. If it is fuzzy, or is a
   fact the repo already records (code structure, git history), ask the user
   what was *non-obvious* about it and capture that instead. Convert relative
   dates ("yesterday", "next week") to absolute ones.

2. **Classify scope** - project vs global (see above).

3. **Pick the mechanism** based on what the learning *is*:

   | The learning is... | Put it in... |
   |---|---|
   | A durable instruction that should shape future agent behavior | `CLAUDE.md` / `AGENTS.md` (project) or the global `AGENTS.md` (global; reached via `~/.claude/CLAUDE.md`) |
   | A reusable multi-step procedure or workflow | a skill (see the `author-skill` skill for the compatible format and where to put it) |
   | Human-facing reference or rationale | project `docs/` or `README.md` |
   | A one-off fact worth recalling later (if the repo uses file-based memory) | the memory system |

4. **Find the existing home before creating a new one.** Search the target
   scope for a file or section that already covers this topic:
   - `CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/`
   - existing skills' `SKILL.md` files

   **Update the existing file or section** rather than appending a duplicate or
   spinning up a new skill. Only create a new skill/doc when nothing fits.

5. **Write it in place, concisely.** Match the surrounding style, headings, and
   density. Put it under the most relevant existing heading. For a correction or
   preference, include the **why** ("do X because Y"); that is what makes it
   stick and prevents regressions. Keep only the durable signal; drop the
   conversation-specific scaffolding.

6. **Confirm.** Tell the user exactly what changed and where (file plus
   section), and, for anything global, that it now applies to every repo.

## Guardrails

- **Smallest change that captures it.** One learning per edit; do not rewrite
  surrounding content.
- **No duplication.** If two files could hold it, pick the most specific correct
  one and link rather than copy.
- **Do not record what is already encoded** in the code, tests, or git history;
  record the insight that is not obvious from them.
- **Global writes are higher-stakes.** Confirm scope with the user before adding
  to the global `AGENTS.md` or a global skill.
- **When the learning becomes a skill, follow the `author-skill` skill** for the
  format and location that both opencode and Claude Code can read.
