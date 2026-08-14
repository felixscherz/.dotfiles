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

## Feature workspaces

Each feature gets a workspace at `docs/agents/<feature>/`. In a multi-context repo, context-scoped feature workspaces live at `docs/<context>/agents/<feature>/`.

The standard files are:

- `docs/agents/<feature>/spec.md` - the feature specification
- `docs/agents/<feature>/ticket-01.md`, `ticket-02.md`, and so on - ordered implementation tickets
- `docs/agents/<feature>/summary-01.md`, `summary-02.md`, and so on - implementation summaries when generated

The spec and summaries are reference documents. Each `ticket-NN.md` is an issue and follows the issue format below.

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

Read the file at the referenced path. The user will normally pass the path or issue number directly. A bare standalone issue number `NN` resolves to `docs/agents/issues/<NN>-*.md` (glob for it). Within a named feature, ticket `NN` resolves to `docs/agents/<feature>/ticket-<NN>.md`.
