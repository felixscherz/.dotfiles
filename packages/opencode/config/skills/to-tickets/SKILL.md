---
name: to-tickets
description: Break a spec, plan, or conversation into vertical-slice tickets with explicit blocking dependencies and write them to the project's issue tracker as ready-for-agent issues. Use when the user says "break this into tickets", "make tickets", "turn the spec into issues", "slice this up", or wants a feature decomposed into agent-pickup-able work.
---

# To tickets

Decompose a spec, plan, or the current conversation into tracer-bullet tickets - each a vertical slice through the stack that an agent can pick up and finish in one session. Publish them as first-class triage issues so `triage` and its pickup flow work on them directly.

## Configuration

Before anything else, look for this repo's config - these tell you where tickets go, their format, and how to talk about the domain:

- `docs/agents/issue-tracker.md` - where issue files live and their format (default if absent: `docs/agents/issues/<NN>-<slug>.md`, or `docs/agents/<feature>/issues/<NN>-<slug>.md` for a feature effort). This is where the tickets are written.
- `docs/agents/triage-states.md` - the actual `Status:` string for `ready-for-agent` (default if absent: the name as-is).
- `docs/agents/domain.md` - domain doc consumer rules. Read `CONTEXT.md`/`CONTEXT-MAP.md` and the ADRs in the area before slicing, and use the glossary's vocabulary in every ticket.

These files are written by the `setup-agents` skill. If they are missing, proceed with the defaults and mention once that `setup-agents` can scaffold them.

## Process

### 1. Gather context

Read the source material:

- A spec at `docs/agents/<feature>/spec.md` (from `to-spec`), a plan, or the current conversation. If the user references a spec or issue, read it in full.
- If the input is only conversation and it is thin, ask the user to firm up the feature (or run `to-spec` first) rather than inventing scope.

### 2. Ground yourself in the codebase

Explore the repo following `docs/agents/domain.md`: read the relevant `CONTEXT.md`/`CONTEXT-MAP.md` and the ADRs that touch the area. Use the project's domain vocabulary in every ticket title and body. Flag any ticket that would contradict a settled ADR (see `docs/agents/domain.md`).

### 3. Draft vertical slices

Cut the work into tickets that each slice completely through the stack - schema, API, UI, tests as applicable - not horizontally through a single layer. Each ticket should be:

- **Independently demoable** - it moves the feature forward on its own.
- **Context-window-sized** - one agent session can finish it.
- **Named in domain vocabulary** - use the glossary's terms.

**Wide refactors are the exception.** Renaming or retyping a shared symbol across many call sites does not vertically slice. Use expand-contract: add the new form alongside the old, migrate call sites in batches, then delete the old form - as a short sequence of tickets.

Work out the blocking edges: which tickets genuinely depend on another being done first. Record real dependencies only, not a false linear chain - sequence so that work can proceed on the frontier (any ticket whose blockers are all done). Express blocking with a `Blocked-by:` line listing the ticket numbers it depends on (omit the line when nothing blocks it).

### 4. Quiz the user

Before publishing, check two things with the user:

- **Granularity** - are the slices the right size? Too coarse to finish in a session, or split so fine they are not independently demoable?
- **Blocking edges** - do the dependencies match their mental model?

Adjust, then publish.

### 5. Publish

Write each ticket as a triage issue file under the feature's `issues/` directory - `docs/agents/<feature>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers get lower numbers). Create the directory if needed. Each ticket uses the standard issue file format (see `docs/agents/issue-tracker.md`) with `Status:` set to `ready-for-agent`, and carries an agent brief written per the `agent-brief.md` template in the `triage` skill - that brief is the contract a future agent session works from.

Ticket file:

```markdown
# <Ticket Title>

Category: enhancement
Status: ready-for-agent
Created: <YYYY-MM-DD>
Blocked-by: 01, 02

<What to build, from the user's perspective - one or two sentences.>

## Agent Brief

<Written per the triage skill's agent-brief.md template: current behavior,
desired behavior, key interfaces, testable acceptance criteria, out of scope.
Behavioral not procedural; no file paths or line numbers.>

## Notes

- <YYYY-MM-DD>: sliced from docs/agents/<feature>/spec.md
```

After publishing, report the feature directory and the ordered list of tickets with their blocking edges, so the user can see the frontier. `triage`'s pickup flow can then take any unblocked `ready-for-agent` ticket.

## Related

- `to-spec` - produces the spec this skill decomposes.
- `triage` - manages these tickets afterwards; its `agent-brief.md` defines the brief each ticket carries, and its pickup flow works them.
- `setup-agents` - owns where tickets live, their format, and the state vocabulary; this skill defers to its output.
