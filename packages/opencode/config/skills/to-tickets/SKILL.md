---
name: to-tickets
description: Validate and break a spec, plan, or conversation into vertical-slice ticket-NN.md files with explicit blocking dependencies. Use when the user says "break this into tickets", "make tickets", "turn the spec into issues", "slice this up", or wants a feature decomposed into agent-pickup-able work.
disable-model-invocation: true
---

# To tickets

Decompose a spec, plan, or the current conversation into tracer-bullet tickets - each a vertical slice through the stack that an agent can pick up and finish in one session. Publish them as first-class triage issues so `triage` and its pickup flow work on them directly.

## Configuration

Before anything else, look for this repo's config - these tell you where tickets go, their format, and how to talk about the domain:

- `.agents/issue-tracker.md` - where issue files live and their format (default if absent: standalone issues at `.agents/issues/<NN>-<slug>.md`; feature tickets at `.agents/features/<feature>/ticket-<NN>.md`). This is where the tickets are written.
- `.agents/triage-states.md` - the actual `Status:` string for `ready-for-agent` (default if absent: the name as-is).
- `.agents/domain.md` - domain doc consumer rules. Read `CONTEXT.md`/`CONTEXT-MAP.md` and the ADRs in the area before slicing, and use the glossary's vocabulary in every ticket.

These files are written by the `setup-agents` skill. If they are missing, proceed with the defaults and mention once that `setup-agents` can scaffold them.

## Process

### 1. Gather context

Read the source material:

- A spec at `.agents/features/<feature>/spec.md` (from `to-spec`), a plan, or the current conversation. If the user references a spec or issue, read it in full.
- If the input is only conversation and it is thin, ask the user to firm up the feature (or run `to-spec` first) rather than inventing scope.

### 2. Validate readiness

Before slicing, check for:

- Blocking open questions, or a feature README (`.agents/features/<feature>/README.md`) that says the spec is not ready for ticketing
- Contradictory requirements or conflicts with settled ADRs
- Missing behavior for important errors, edge cases, migration, or compatibility
- Acceptance criteria that are too vague to verify
- Unsettled architecture or contracts that separate ticket agents could implement inconsistently

Resolve anything that can be established from the codebase. If a material gap remains, stop and ask the user one focused question at a time, or recommend returning to `to-spec`. Do not publish tickets that require agents to invent shared requirements or architecture.

### 3. Ground yourself in the codebase

Explore the repo following `.agents/domain.md`: read the relevant `CONTEXT.md`/`CONTEXT-MAP.md` and the ADRs that touch the area. Use the project's domain vocabulary in every ticket title and body. Flag any ticket that would contradict a settled ADR (see `.agents/domain.md`).

### 4. Draft vertical slices

Cut the work into tickets that each slice completely through the stack - schema, API, UI, tests as applicable - not horizontally through a single layer. Each ticket should be:

- **A meaningful commit** - completing the ticket produces one coherent, self-contained change worth committing on its own. This is the primary sizing rule.
- **Independently demoable** - it moves the feature forward in a way you could point at.
- **Context-window-sized** - one agent session can finish it. A ticket must fit in a session, but fitting is the ceiling, not the target.
- **Named in domain vocabulary** - use the glossary's terms.

**Size for meaningful progress, not for parallelism.** The goal is a sequence of substantial steps, each of which advances the feature in a way a reviewer can follow - not the largest possible number of tickets that could run at once. When unsure, prefer the coarser slice: splitting too fine scatters one coherent change across several tickets and loses the bigger picture. Only split when a ticket would no longer fit one session, or when two parts are genuinely independent changes rather than one.

**Wide refactors are the exception.** Renaming or retyping a shared symbol across many call sites does not vertically slice. Use expand-contract: add the new form alongside the old, migrate call sites in batches, then delete the old form - as a short sequence of tickets.

Work out the blocking edges: which tickets genuinely depend on another being done first. Record real dependencies only, not a false linear chain. Sequence the tickets so the feature is built up in a sensible order of meaningful commits; express blocking with a `Blocked-by:` line listing the ticket numbers it depends on (omit the line when nothing blocks it). Parallelism, where it exists, is a byproduct of real independence - never a reason to slice finer.

### 5. Quiz the user

Before publishing, check two things with the user:

- **Granularity** - is each ticket one meaningful commit? Flag any that are too big to finish in a session, and any split so fine that a single coherent change was scattered across several tickets.
- **Blocking edges** - do the dependencies match their mental model?

Adjust, then publish.

### 6. Publish

Write each ticket as a triage issue file directly in the feature directory - `.agents/features/<feature>/ticket-<NN>.md`, numbered from `01` in dependency order (blockers get lower numbers). In a multi-context repo use `.agents/<context>/features/<feature>/ticket-<NN>.md`. Each ticket uses the canonical issue file format from the `triage` skill with `Status:` set to `ready-for-agent`, and carries an agent brief written per the `agent-brief.md` template in the `triage` skill - that brief is the contract a future agent session works from.

Ticket file:

```markdown
# Ticket <NN>: <Ticket Title>

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

- <YYYY-MM-DD>: sliced from .agents/features/<feature>/spec.md
```

Update the feature README (`.agents/features/<feature>/README.md`) with the ticket list and blocking edges, and set its status to "tickets published". Create the README if `to-spec` did not.

After publishing, report the feature directory and the ordered list of tickets with their blocking edges, so the user can see the frontier. `triage`'s pickup flow can then take any unblocked `ready-for-agent` ticket.

## Related

- `to-spec` - produces the spec this skill decomposes.
- `triage` - manages these tickets afterwards; its `agent-brief.md` defines the brief each ticket carries, and its pickup flow works them.
- `setup-agents` - owns where tickets live, their format, and the state vocabulary; this skill defers to its output.
