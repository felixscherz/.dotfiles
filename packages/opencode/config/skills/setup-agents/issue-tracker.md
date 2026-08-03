# Issue tracker: Markdown under docs/agents

Issues for this repo live as tracked markdown files under `docs/agents/` - committed with the code and visible in editor autocomplete. In a multi-context repo they live under `docs/<context>/agents/` for the context they belong to.

## Conventions

- One file per issue at `docs/agents/issues/<NN>-<slug>.md`, numbered from `01` - the next number is one above the highest existing
- Issues that belong to a larger effort with its own `docs/agents/<feature>/` directory may live at `docs/agents/<feature>/issues/<NN>-<slug>.md` instead
- Each issue file carries near the top:
  - `Category:` - `bug` or `enhancement`
  - `Status:` - the triage state (see `docs/agents/triage-states.md`)
  - `Created:` - ISO date (`YYYY-MM-DD`)
- Notes and conversation history append to the bottom under a `## Notes` heading, date-prefixed, newest last
- A resolved issue keeps its file; the `Status:` line moves to `done` or `wontfix`

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

Create a new file under `docs/agents/issues/` (or the feature's `issues/` directory), taking the next free number. Create the directory if needed.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly; a bare number `NN` resolves to `docs/agents/issues/<NN>-*.md` (glob for it).
