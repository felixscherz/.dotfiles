# Skills

Global agent skills live in the dedicated `skills` package, stowed to `~/.agents/skills`. OpenCode and Claude Code also have compatibility symlinks to this directory. See `author-skill` for the shared format and conventions.

This file is the index of how the skills fit together. Update it when adding or removing a skill (`author-skill` reminds you).

## The two clusters

**Delivery pipeline** - issue capture through implementation and review, built around a per-repo `.agents/` directory:

```
setup-agents        scaffold a repo's .agents config (once per repo)
     |
   triage           capture and manage issues (.agents/issues/), the front door
     |
   to-spec          fold issues/discussion into a feature spec
     |                (.agents/features/<feature>/spec.md + README.md)
   to-tickets       slice the spec into vertical-slice tickets (ticket-NN.md)
     |
batch-implement     generate a script that runs tickets through a harness
     |
   catch-up         walk the human through what changed; review against the spec
     |
ship-feature        final sign-off: verify against the spec, surface drift,
                       close source issues, open the pull request
```

Sibling setup skill, also run once per repo: `setup-repository` productionizes a repo for tagged releases - generated release notes, CI for format/lint/test, prek/pre-commit hooks, LICENSE, and a documented release workflow. It is independent of the pipeline and does not read `.agents/`.

The feature workspace `.agents/features/<feature>/` accumulates: `README.md` (free-form progression doc holding the feature's status and history), `spec.md`, `ticket-NN.md`, `summary-NN.md`, plus the generated `implement.sh` / `progress.json`. The canonical issue file format lives in the `triage` skill; everything else references it.

`agents-folder` governs the personal `.agents/` workspace, including whether its contents enter a repo's history. In repos that have not adopted a structure, personal workspace files stay uncommitted and outward prose (PR descriptions, commit messages) must not reference their paths.

**Task workspace** - `agents-folder` gives any agent a per-task folder at `.agents/tasks/<task-id>/` in the primary checkout. Agents use it for scratch files, documents for the user (summaries, plans, write-ups), handoff notes for the next agent, and shared state when several agents work on one task. Each folder has a `README.md` index; agents only edit files they created. An orchestrator uses the same folder for its assignments and reports. Task folders stay out of git history via the local exclude file.

**Working style** - how sessions run, independent of the pipeline:

- `pair-program` (+ `DESIGN.md`) - human as navigator, agent as driver, small reviewed steps. The hands-on alternative to the pipeline; `catch-up` is its after-the-fact counterpart.
- `worktree-isolation` - create an isolated checkout under the repository's `.worktrees/` directory and perform the requested work there.
- `unslop` - cut AI tells from outward-facing prose. Triggered by other skills referencing it, or when writing for a human audience (PR text, tickets, posts, docs).
- `html-communication` - produce a self-contained HTML document for human communication (plans, specs, write-ups, summaries). Not for product HTML or frontend UI design.
- `record-learnings` - route a realization to its durable home (CLAUDE.md/AGENTS.md, a skill, docs, memory).
- `author-skill` - how to write and place skills themselves.
- `workspace-layout` - resolve logical names for local repositories and documents. Its `scripts/find-workspace.sh` selects the nearest `.workspace/WORKSPACE.md` above the session's starting directory or the personal default at `~/.config/workspace-layout/WORKSPACE.md`. Other skills can use it without assuming the developer's directory layout; setup creates the mapping outside the skill directory.
- `agents-folder` - per-task workspace under `.agents/tasks/` for scratch files, user-facing documents, handoffs, and multi-agent coordination.

## Invocation policy

Pipeline stages that create artifacts on explicit demand are user-invocable only: `setup-agents`, `setup-repository`, `to-spec`, `to-tickets`, `batch-implement`, `ship-feature`. This is enforced twice, and both must stay in sync: `disable-model-invocation: true` in the skill frontmatter (Claude Code) and `permission.skill` denies in `opencode.json` (opencode). Everything else may be model-invoked when its description matches.

## Per-repo state the pipeline reads

Written by `setup-agents` into each repo:

- `.agents/issue-tracker.md` - where issues live (format defers to `triage`)
- `.agents/triage-states.md` - the `Status:` vocabulary
- `.agents/domain.md` - domain doc layout: `CONTEXT.md`, ADRs, glossary rules

All pipeline skills read these first and fall back to documented defaults when they are missing.
