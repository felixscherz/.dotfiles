---
name: triage
description: Triage issues tracked as markdown files under docs/agents - capture bugs and ideas found together during a session, categorize, verify against the codebase, and move them through triage states until done or wontfix. Use when the user says "triage", "record this issue", "track this for later", "add this to the tracker", "what needs attention", or wants to pick up a previously recorded issue.
---

# Triage

Move issues through a small state machine of triage states. Issues are local markdown files - things found together with the user during sessions and recorded for later, not external reports. The user is both reporter and maintainer.

## Configuration

Before anything else, look for this repo's config:

- `docs/agents/issue-tracker.md` - where issue files live and their conventions (default if absent: `docs/agents/issues/<NN>-<slug>.md`, format below)
- `docs/agents/triage-states.md` - the actual `Status:` strings for the canonical states (default if absent: the canonical names as-is)
- `docs/agents/domain.md` - domain doc consumer rules; read `CONTEXT.md` and relevant ADRs before exploring the codebase

These files are written by the `setup-agents` skill. If they are missing, proceed with the defaults and mention once that `setup-agents` can scaffold them.

## States

Two **categories** (the `Category:` line):

- `bug` - something is broken
- `enhancement` - new feature or improvement

Six **states** (the `Status:` line):

- `needs-triage` - captured, not yet evaluated
- `needs-info` - waiting on the user for more info or a decision
- `ready-for-agent` - fully specified, an agent can pick it up (agent brief in the file)
- `ready-for-human` - needs human implementation
- `wontfix` - will not be actioned (reason recorded in the file)
- `done` - implemented and verified

Every issue file carries exactly one category and one state. Transitions: a new issue normally starts at `needs-triage`; from there to `needs-info`, `ready-for-agent`, `ready-for-human`, or `wontfix`. `needs-info` returns to `needs-triage` once the user answers. Worked issues end at `done`. The user can override at any time - flag transitions that look unusual and ask before proceeding.

## Issue file format

```markdown
# <Title>

Category: bug | enhancement
Status: needs-triage
Created: 2026-07-31

<Body: what was found, repro steps for a bug, context from the session.>

## Notes

- 2026-07-31: <note>
```

Standalone issues live at `docs/agents/issues/<NN>-<slug>.md`, numbered from `01` - next number is one above the highest existing. Feature tickets live directly in the feature workspace as `docs/agents/<feature>/ticket-<NN>.md`, alongside its `spec.md`. A bare standalone issue number `NN` resolves by globbing `docs/agents/issues/<NN>-*.md`; a feature ticket number must be paired with its feature name or path. In a multi-context repo, use `docs/<context>/agents/`. These are tracked docs - committed with the code and visible in editor autocomplete.

## Invocation

The user describes what they want in natural language. Interpret the request and act. Examples:

- "Record this issue" / "track this for later" -> capture flow
- "What needs attention?" -> attention list
- "Let's look at issue 03" -> triage flow
- "Move 03 to ready-for-agent" -> quick state override
- "Pick up 02" -> pickup flow

## Capture a new issue

The common case: you and the user just found something worth tracking mid-session.

1. Write the issue file with everything already known from the session - repro steps, code pointers, hypotheses. Don't make the user re-explain what you both just saw.
2. Set `Status:` to `needs-triage` by default. If the issue is already fully understood and specified, propose `ready-for-agent` directly and write the agent brief too.
3. Report the path so the user can find it. One line: what was captured and where.

Capture is cheap - when in doubt, record.

## Show what needs attention

Scan the issue directories and present three buckets, oldest first:

1. **`needs-triage`** (or a missing `Status:` line) - not yet evaluated
2. **`needs-info`** - waiting on the user
3. **`ready-for-agent`** - specced, can be picked up right away

Show counts and a one-line summary per item (number, title, age). Let the user pick.

## Triage a specific issue

1. **Gather context.** Read the full issue file including notes. Explore the codebase using the project's domain glossary, respecting ADRs in the area. Run two checks against the codebase: (a) **redundancy** - search for an existing implementation of the requested behavior by domain concept, not just the issue's wording, and report where you looked. If found, it is an already-implemented `wontfix` (step 5). (b) **still valid** - for a bug, does the described broken behavior still exist?
2. **Recommend.** Tell the user your category and state recommendation with reasoning, plus a brief codebase summary relevant to the issue. Wait for direction.
3. **Verify the claim.** Before any grilling, check that the claim holds up. For a bug, reproduce it from the recorded steps. Report what happened: confirmed (with code path), failed, or insufficient detail (a strong `needs-info` signal). A confirmed verification makes a much stronger agent brief.
4. **Grill (if needed).** If the issue needs fleshing out, ask the user one focused question at a time until it is specced. Append resolved points to the file's notes as decisions land. Sharpen domain terms inline - when a term or decision lands for the first time, propose adding it to `CONTEXT.md` or recording an ADR (see `docs/agents/domain.md`).
5. **Apply the outcome** by editing the issue file:
   - `ready-for-agent` - write an agent brief into the file ([agent-brief.md](./agent-brief.md)).
   - `ready-for-human` - same structure as an agent brief, plus a note why it can't be delegated (judgment calls, external access, design decisions, manual testing).
   - `needs-info` - append triage notes (template below).
   - `wontfix` - record the reason in the file. **Already implemented**: point to where it lives. **Rejected**: record why.
   - `done` - only after the work is actually verified.
   - `needs-triage` - set the state; optional note if there is partial progress.

## Pick up a ready issue

When the user asks to work on a `ready-for-agent` (or `ready-for-human`) issue:

1. Read the issue file. The agent brief is the contract; body and notes are context.
2. Re-validate against the current codebase before implementing - things may have changed since the brief was written. If the brief is stale, say so and re-triage first.
3. Implement, then verify every acceptance criterion.
4. Set `Status: done`, append a closing note (what changed, how verified).

## Quick state override

If the user says "move 03 to ready-for-agent", trust them and apply the state directly. Confirm what you are about to do, then act. Skip grilling. If moving to `ready-for-agent` without a grilling session, ask whether they want an agent brief written.

## Needs-info notes template

```markdown
## Notes

- 2026-07-31 triage: established so far - <point 1>; <point 2>.
  Still needed from the user: <specific question 1>; <specific question 2>.
```

Capture everything resolved during grilling under "established so far" so the work isn't lost. Questions must be specific and actionable, not "please provide more info".

## Resuming a previous session

If the issue file already has notes, read them, check whether the outstanding questions have been answered since, and present an updated picture before continuing. Don't re-ask resolved questions.
