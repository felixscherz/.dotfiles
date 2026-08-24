---
name: setup-agents
description: Configure a repo for agent workflows - scaffold the .agents issue tracker config, triage state vocabulary, and domain doc layout (CONTEXT.md, .agents/, docs/adrs/). Run once per repo before first use of the triage skill. Use when the user says "setup agents", "set up agent docs", "scaffold agent config", or asks for .agents or CONTEXT.md conventions in a repo.
---

# Setup agents

Scaffold the per-repo configuration that the agent skills assume:

- **Issue tracker** - where issues live (tracked markdown under `.agents/` by default)
- **Triage states** - the `Status:` strings used for the canonical triage states
- **Domain docs** - where `CONTEXT.md`, ADRs, and agent docs live, and the rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `AGENTS.md` and `CLAUDE.md` at the repo root - does either exist? Is there already an `## Agent setup` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `.agents/` - what is already there? Does this skill's prior output already exist?
- `docs/adrs/` and any `docs/*/adrs/` directories
- `.agents/issues/` (or `.agents/<context>/issues/` in a monorepo) - sign that the markdown issue-tracker conventions are already in use. A legacy `docs/agents/` tree means an older layout; offer to migrate it under `.agents/`.
- Monorepo signals - `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, `go.work`, a `[workspace]` table in `Cargo.toml`, or a populated `packages/*` or `apps/*` whose members have their own README or `src/`. Their absence means single-context, which is almost every repo.

### 2. Present findings and ask

Summarise what is present and what is missing. Then take the sections in order - one section, one answer, then the next. Lead each section with the recommended answer so the user can accept it in a word. Skip a section entirely when exploration already settled it (Section C when there are no monorepo signals).

**Section A - Issue tracker.**

Default: issues live as tracked markdown files under `.agents/issues/` in this repo - committed with the code and visible in editor autocomplete. Good for solo work and for issues found together with an agent during a session.

> Do you want to track issues as markdown under `.agents/`? (recommended: **yes**)

On **yes**, record it using the [issue-tracker.md](./issue-tracker.md) template. Only if the user says no - usually because the repo already tracks work elsewhere (GitHub Issues, Jira, Linear) - ask them to describe the workflow in one paragraph and record that as freeform prose in `.agents/issue-tracker.md` instead.

**Section B - Triage state vocabulary.**

Ask exactly one question:

> Do you want to keep the default triage states? (recommended: **yes**)

The defaults are the canonical states, each `Status:` string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`, `done`. On **yes**, write them as-is using the [triage-states.md](./triage-states.md) template. Only if the user says no, collect the overrides so `triage` uses their vocabulary.

**Section C - Domain docs.**

Default to **single-context** - one `CONTEXT.md` at the repo root, ADRs in `docs/adrs/`, agent docs in `.agents/`. This fits almost every repo; write it without asking.

Offer **multi-context** - a root `CONTEXT-MAP.md` pointing to per-context `docs/<context>/CONTEXT.md` files, with `docs/<context>/adrs/` and `.agents/<context>/` per context - only when exploration found monorepo signals. Then confirm which layout they want.

If the layout's root file (`CONTEXT.md`, or `CONTEXT-MAP.md` for multi-context) does not exist yet, include seeding a minimal one (step 4) in the plan shown at the confirm step. Create it only if the user does not object.

**Important**: When writing the generated `.agents/domain.md`, only include the layout that applies to this repo. For single-context repos, strip the multi-context file structure section entirely so the file is not cluttered with irrelevant information.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent setup` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `.agents/issue-tracker.md`, `.agents/triage-states.md`, and `.agents/domain.md`
- Any seed files (`CONTEXT.md` or `CONTEXT-MAP.md`)

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create - don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) - always edit the one that is already there.

If an `## Agent setup` block already exists in the chosen file, update its contents in place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

````markdown
## Agent setup

### Issue tracker

[one-line summary of where issues are tracked]. See `.agents/issue-tracker.md`.

### Triage states

[one-line summary of the state vocabulary]. See `.agents/triage-states.md`.

### Domain docs

[one-line summary of layout - "single-context" or "multi-context"]. See `.agents/domain.md`.
````

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker.md](./issue-tracker.md) - local-markdown issue tracker (includes the `.agents/features/<feature>/` workspace convention)
- [triage-states.md](./triage-states.md) - triage state mapping
- [domain.md](./domain.md) - domain doc consumer rules + layout (the template includes both layouts; for single-context repos, strip the multi-context section from the generated file so it only describes the layout actually in use)

Seed files when confirmed:

- Single-context, no `CONTEXT.md` yet:

````markdown
# Context

Domain glossary and shared vocabulary for this repo.

## Glossary

| Term | Meaning | Avoid |
| ---- | ------- | ----- |
````

- Multi-context, no `CONTEXT-MAP.md` yet:

````markdown
# Context Map

This repo has multiple domain contexts. Each context has its own `CONTEXT.md`; system-wide decisions live in `docs/adrs/`.

| Context | CONTEXT.md | Notes |
| ------- | ---------- | ----- |
````

### 5. Done

Tell the user the setup is complete and that the agent skills will now read from these files: `triage` (issue tracker, triage states, domain), `to-spec` (domain docs, and where the spec goes), and `to-tickets` (issue tracker, `ready-for-agent` state, domain). Mention they can edit `.agents/*.md` directly later - re-running this skill is only necessary to switch trackers or start over.

Also explain the layout and the flow it supports. `.agents/` holds the agent-created and agent-consumed docs; human-facing docs (`CONTEXT.md`, ADRs) stay in their normal locations. Within `.agents/`:

- `.agents/issues/<NN>-<slug>.md` - standalone issues, the front door. Every idea, problem, bug, or feature request is captured here first (via `triage`), where they accumulate.
- `.agents/features/<feature>/` - a feature workspace: `spec.md` (from `to-spec`, which can fold in several accumulated issues), then `ticket-01.md`, `ticket-02.md`, and so on (from `to-tickets`).

The workflow: capture issues as they come up, let them accumulate, then `to-spec` turns one or more of them into a feature spec and `to-tickets` slices it into tickets an agent can pick up.
