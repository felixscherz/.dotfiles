# Issue tracker: Markdown under docs/agents

Issues for this repo live as tracked markdown files under `docs/agents/issues/` - committed with the code and visible in editor autocomplete. In a multi-context repo they live under `docs/<context>/agents/issues/` for the context they belong to.

## Conventions

- One file per issue at `docs/agents/issues/<NN>-<slug>.md`, numbered from `01` - the next number is one above the highest existing
- Each issue file carries near the top:
  - `Category:` - `bug` or `enhancement`
  - `Status:` - the triage state (see `docs/agents/triage-states.md`)
  - `Created:` - ISO date (`YYYY-MM-DD`)
- Notes and conversation history append to the bottom under a `## Notes` heading, date-prefixed, newest last
- A resolved issue keeps its file; the `Status:` line moves to `done` or `wontfix`

## Feature docs

Feature-level documents (specs, plans, handoffs, implementation notes) live under `docs/agents/features/`. In a multi-context repo, context-scoped feature docs live under `docs/<context>/agents/features/`; system-wide features use `docs/agents/features/`.

A feature can be either:

- A single markdown file: `docs/agents/features/<slug>.md`
- A folder with multiple files: `docs/agents/features/<slug>/<file>.md`

These are not issues - they are longer-lived reference documents that accompany a body of work.

## Issue file format

```markdown
# <Title>

Category: bug | enhancement
Status: needs-triage
Created: 2026-07-31

<Body: what was found, repro steps for a bug, context from the session.>

## Notes

- 2026-07-31: <first note>
```

## When a skill says "publish to the issue tracker"

Create a new file under `docs/agents/issues/`, taking the next free number. Create the directory if needed.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly; a bare number `NN` resolves to `docs/agents/issues/<NN>-*.md` (glob for it).
