# Issue tracker: Markdown under .agents

Issues for this repo live as tracked markdown files under `.agents/issues/` - committed with the code and visible in editor autocomplete. In a multi-context repo they live under `.agents/<context>/issues/` for the context they belong to.

## Conventions

- One file per issue at `.agents/issues/<NN>-<slug>.md`, numbered from `01` - the next number is one above the highest existing
- Each issue file carries near the top:
  - `Category:` - `bug` or `enhancement`
  - `Status:` - the triage state (see `.agents/triage-states.md`)
  - `Created:` - ISO date (`YYYY-MM-DD`)
- Notes and conversation history append to the bottom under a `## Notes` heading, date-prefixed, newest last
- A resolved issue keeps its file; the `Status:` line moves to `done` or `wontfix`

## Feature workspaces

Each feature gets a workspace at `.agents/features/<feature>/`. In a multi-context repo, context-scoped feature workspaces live at `.agents/<context>/features/<feature>/`.

The standard files are:

- `.agents/features/<feature>/spec.md` - the feature specification
- `.agents/features/<feature>/ticket-01.md`, `ticket-02.md`, and so on - ordered implementation tickets
- `.agents/features/<feature>/summary-01.md`, `summary-02.md`, and so on - implementation summaries when generated

The spec and summaries are reference documents. Each `ticket-NN.md` is an issue and follows the issue format below.

A feature commonly addresses several accumulated issues at once. When `to-spec` folds issues in, it lists them in the spec's **Source Issues** section and links back from each issue file. Those source issues stay open and move to `done` only when the feature ships.

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

Create a new file under `.agents/issues/`, taking the next free number. Create the directory if needed.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or issue number directly. A bare standalone issue number `NN` resolves to `.agents/issues/<NN>-*.md` (glob for it). Within a named feature, ticket `NN` resolves to `.agents/features/<feature>/ticket-<NN>.md`.
