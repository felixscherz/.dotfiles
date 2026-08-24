---
name: to-spec
description: Turn a technical or product discussion into an implementation-ready specification covering requirements, architecture, contracts, decisions, and verification. Use when the user says "write a spec", "turn this into a spec", "spec this out", "make a PRD", or wants the current discussion captured before breaking it into tickets.
---

# To spec

Turn the current conversation and codebase understanding into a durable technical specification. Preserve the substance of technical discussions: architecture, patterns, interfaces, schemas, examples, tradeoffs, and decisions. User stories are optional supporting material, not the structure of the spec.

A spec can also be assembled from accumulated issues. Issues pile up in `.agents/issues/` as problems and requests are captured; a feature is often the right response to several of them at once. When the user points at a set of issues (or asks you to fold in everything about an area), read those issues and synthesize them into one coherent spec, then record them as the spec's source issues so their lifecycle closes when the feature ships.

Synthesize everything already established before asking questions. Ask only about unresolved points that materially affect behavior, architecture, scope, compatibility, migration, or verification. Do not invent decisions to make the document look complete.

## Configuration

Before anything else, look for this repo's config - these tell you where the spec goes and what to read for context:

- `.agents/domain.md` - domain doc consumer rules. Read `CONTEXT.md` (or `CONTEXT-MAP.md`) and the ADRs in the area you are touching before writing the spec. Use the glossary's vocabulary throughout.
- `.agents/issue-tracker.md` - where tracked work lives and its conventions (default if absent: markdown under `.agents/`, with a feature workspace at `.agents/features/<feature>/`).

These files are written by the `setup-agents` skill. If they are missing, proceed with the defaults and mention once that `setup-agents` can scaffold them.

## Process

### 1. Gather the established material

Review the full relevant conversation and any prototypes, plans, examples, or documents the user referenced. Extract decisions and constraints without reducing technical details to generic product language.

If the feature draws on tracked issues, read each source issue in full - body and notes - from `.agents/issues/`. Treat them as raw input, not as the spec's structure: reconcile overlaps, resolve contradictions between them, and note any that turn out to be out of scope so you can leave them tracked rather than fold them in. Keep the list of issue files you actually incorporated; you will record and link them in step 4.

Explore the repo to understand the current state if this has not already happened during the conversation. Follow `.agents/domain.md`: read the relevant `CONTEXT.md`/`CONTEXT-MAP.md` and ADRs. Search for analogous implementations and tests. Respect settled ADRs; if the proposed design contradicts one, identify the conflict instead of silently overriding it.

### 2. Check specification readiness

Determine whether the material answers the questions needed for implementation:

- Is the desired behavior concrete and testable, including important errors and edge cases?
- Are component responsibilities, interfaces, and ownership boundaries sufficiently clear?
- Are architecture-affecting decisions settled or deliberately delegated?
- Are compatibility, persistence, rollout, and migration requirements known where relevant?
- Are important security, performance, observability, or operational constraints known where relevant?
- Can the behavior be verified at stable seams?
- Can `to-tickets` decompose the work without inventing requirements or making inconsistent design decisions across tickets?

If a missing answer materially changes the implementation, ask the user one focused question at a time. Explain the consequence of the decision when useful. Do not interview for information that can be established from the codebase, and do not ask optional questions merely to fill every template section.

If the user chooses not to resolve a material question, record it under **Open Questions**, state its impact, and mark the spec as not ready for ticketing. Non-blocking questions may remain without preventing ticketing.

### 3. Define verification seams

Identify the stable seams at which the behavior will be tested. Prefer existing public or high-level seams over new low-level seams. Record relevant prior art in the codebase and any manual or operational verification that automated tests cannot cover.

Ask for confirmation only if the selected seam changes the public design, leaves a meaningful coverage gap, or conflicts with an expectation the user expressed.

### 4. Write the spec

Write the spec using the template below and save it to `.agents/features/<feature-slug>/spec.md`. Create the feature directory; `<feature-slug>` is a short kebab-case name. In a multi-context repo, use `.agents/<context>/features/<feature-slug>/spec.md`.

The spec is the authoritative input to `to-tickets`, which writes `ticket-01.md`, `ticket-02.md`, and so on in the same feature directory. The spec is a document, not a triage issue, and does not carry a `Status:` line.

Omit sections that truly do not apply rather than filling them with boilerplate. Retain detail when it constrains implementation.

**Link the source issues.** If the spec folded in tracked issues, list them in the spec's **Source Issues** section, and append a note to each source issue file pointing at the feature - e.g. `- <YYYY-MM-DD>: folded into .agents/features/<feature-slug>/spec.md`. Do not close the source issues now: they remain open and are moved to `done` only when the feature actually ships (that is `triage`'s job as the tickets complete). If an issue you read turned out to be out of scope, leave it untouched and say so.

Report the path and whether the spec is ready for ticketing. If ready, tell the user they can run `to-tickets`. If not ready, list only the blocking open questions. If source issues were folded in, name them and confirm each was linked back.

## Spec template

```markdown
# <Feature Title>

## Status

Ready for ticketing | Draft - blocked by open questions

## Problem and Goals

The current problem, desired outcomes, and the users or systems affected.

### Source Issues

The tracked issues this feature addresses, each linked by path (e.g.
`.agents/issues/03-<slug>.md`). Omit this section when the spec came only from
conversation. These issues close to `done` when the feature ships, not now.

### Non-goals

Explicit scope boundaries and adjacent work this specification does not cover.

## Current System

Relevant existing behavior, components, interfaces, data flows, and constraints.
Include analogous implementations and settled ADRs that shape the design.

## Requirements

Numbered, testable requirements covering observable behavior, errors, edge cases,
and compatibility. Include operational or quality requirements when relevant.

Optional user stories may appear here when they clarify product behavior, but
they do not replace precise requirements.

## Proposed Design

### Architecture and Responsibilities

Components involved, their responsibilities, and how they collaborate.

### Control and Data Flow

Important request, event, state, or data flows. Cover failure paths where they
affect the design.

### Interfaces and Contracts

API contracts, types, schemas, configuration, persistence, events, and other
boundaries that implementations must honor.

### Migration and Compatibility

Rollout, data migration, compatibility, and removal sequencing where relevant.

## Decisions and Rationale

Decisions established during discussion, alternatives considered, and why the
selected approach was chosen. Identify any ADR that should be created or
superseded.

## Implementation Constraints

Required patterns, existing abstractions to reuse, prohibited approaches,
sequencing constraints, and technical clarifications that tickets must retain.

## Verification

- Observable acceptance criteria
- Automated test seams and relevant prior art
- Manual, integration, migration, or operational verification where needed

## Open Questions

For each unresolved question, state the decision needed, its impact, and whether
it blocks ticketing. Omit this section when there are no open questions.
```

## Technical detail policy

Use precise technical artifacts when they encode a contract better than prose:

- Type and function signatures
- API request and response examples
- Schemas and configuration shapes
- State machines, sequence diagrams, and pseudocode
- Small code snippets that establish a required pattern or invariant

Mark examples as normative or illustrative when ambiguity is possible:

- **Normative**: the implementation should follow it directly. Deviating breaks a
  contract, integration, or test (API shapes, config keys, DTO signatures, error
  mappings).
- **Illustrative**: communicates the approach but is not meant literally. The
  implementer may adapt it to local style as long as the required behavior and
  ordering hold (pseudocode, composition sketches).

Keep only the decision-rich portion. File paths and current implementation pointers are allowed in **Current System** as evidence, but do not make transient line numbers or an exact edit recipe part of the required design.

## Related

- `to-tickets` - validates and decomposes a ready spec into `ticket-NN.md` issues in the same feature directory.
- `setup-agents` - owns where the spec lives and which context docs to read; this skill defers to its output.
- `triage` - manages the ticket files that `to-tickets` produces from this spec.
