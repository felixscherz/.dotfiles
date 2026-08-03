---
name: to-spec
description: Turn the current conversation into a spec (PRD) and write it to the project's issue tracker - no interview, just synthesis of what you and the user have already discussed. Use when the user says "write a spec", "turn this into a spec", "spec this out", "make a PRD", or wants the current discussion captured as a spec before breaking it into tickets.
---

# To spec

Take the current conversation and codebase understanding and produce a spec (you may know this as a PRD). Do NOT interview the user - synthesize what you already know together. If the conversation is thin, say so and ask the user to discuss the feature first rather than inventing requirements.

## Configuration

Before anything else, look for this repo's config - these tell you where the spec goes and what to read for context:

- `docs/agents/domain.md` - domain doc consumer rules. Read `CONTEXT.md` (or `CONTEXT-MAP.md`) and the ADRs in the area you are touching before writing the spec. Use the glossary's vocabulary throughout.
- `docs/agents/issue-tracker.md` - where tracked work lives and its conventions (default if absent: markdown under `docs/agents/`, feature efforts under `docs/agents/<feature>/`).

These files are written by the `setup-agents` skill. If they are missing, proceed with the defaults and mention once that `setup-agents` can scaffold them.

## Process

### 1. Ground yourself in the codebase

Explore the repo to understand the current state, if you haven't already during the conversation. Follow `docs/agents/domain.md`: read the relevant `CONTEXT.md`/`CONTEXT-MAP.md` and any ADRs that touch the area. Use the project's domain vocabulary throughout the spec and respect existing ADRs. If the spec would contradict a settled ADR, flag it explicitly (see `docs/agents/domain.md`) rather than silently overriding.

### 2. Sketch the testing seams

Identify the seams at which the feature will be tested. Prefer existing seams to new ones, and use the highest seam possible - the fewer seams across the codebase, the better, and the ideal is one. If new seams are needed, propose them at the highest point you can.

Check with the user that these seams match their expectations before writing the spec.

### 3. Write the spec

Write the spec using the template below and save it to `docs/agents/<feature-slug>/spec.md` (create the feature directory - `<feature-slug>` is a short kebab-case name for the feature; in a multi-context repo use `docs/<context>/agents/<feature-slug>/spec.md`). This spec is the input `to-tickets` reads to produce the numbered, `ready-for-agent` issue files under `docs/agents/<feature-slug>/issues/`. The spec itself is a document, not a triage issue - it does not carry a `Status:` line.

Report the path, then tell the user they can run `to-tickets` to break the spec into vertical-slice tickets.

## Spec template

```markdown
# <Feature Title>

## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories, each in the format:

1. As an <actor>, I want a <feature>, so that <benefit>

Example:

1. As a mobile bank customer, I want to see the balance on my accounts, so that I can make better informed decisions about my spending.

Make this list extensive - cover all aspects of the feature.

## Implementation Decisions

Decisions that were made. This can include:

- The modules that will be built or modified
- The interfaces of those modules that will change
- Technical clarifications from the user
- Architectural decisions (note any new ADR that should be recorded - see docs/agents/domain.md)
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets - they go stale quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (a state machine, reducer, schema, or type shape), inline just the decision-rich part and note that it came from a prototype.

## Testing Decisions

- What makes a good test here (test external behavior, not implementation details)
- Which modules will be tested, and at which seams (from step 2)
- Prior art - similar tests already in the codebase

## Out of Scope

What is explicitly out of scope for this spec.

## Further Notes

Anything else worth recording about the feature.
```

## Related

- `to-tickets` - reads this spec and decomposes it into vertical-slice `ready-for-agent` issues.
- `setup-agents` - owns where the spec lives and which context docs to read; this skill defers to its output.
- `triage` - manages the issue files that `to-tickets` produces from this spec.
