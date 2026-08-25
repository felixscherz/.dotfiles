# Skills

Global agent skills, shared across harnesses. opencode reads this directory natively; Claude Code reads it through the `~/.claude/skills` symlink. Skills aim to be compatible with a broad range of harnesses - see `author-skill` for the format and conventions.

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
```

The feature workspace `.agents/features/<feature>/` accumulates: `README.md` (free-form progression doc holding the feature's status and history), `spec.md`, `ticket-NN.md`, `summary-NN.md`, plus the generated `implement.sh` / `progress.json`. The canonical issue file format lives in the `triage` skill; everything else references it.

**Working style** - how sessions run, independent of the pipeline:

- `pair-program` (+ `DESIGN.md`) - human as navigator, agent as driver, small reviewed steps. The hands-on alternative to the pipeline; `catch-up` is its after-the-fact counterpart.
- `unslop` - cut AI tells from outward-facing prose. Triggered by other skills referencing it, or when writing for a human audience (PR text, tickets, posts, docs).
- `html-communication` - produce a self-contained HTML document for human communication (plans, specs, write-ups, summaries). Not for product HTML or frontend UI design.
- `handoff` - compact a session into a handoff doc for a fresh agent (user-invoked; asks where to save).
- `record-learnings` - route a realization to its durable home (CLAUDE.md/AGENTS.md, a skill, docs, memory).
- `author-skill` - how to write and place skills themselves.

## Invocation policy

Pipeline stages that create artifacts on explicit demand are user-invocable only: `setup-agents`, `to-spec`, `to-tickets`, `batch-implement`, `handoff`. This is enforced twice, and both must stay in sync: `disable-model-invocation: true` in the skill frontmatter (Claude Code) and `permission.skill` denies in `opencode.json` (opencode). Everything else may be model-invoked when its description matches.

## Per-repo state the pipeline reads

Written by `setup-agents` into each repo:

- `.agents/issue-tracker.md` - where issues live (format defers to `triage`)
- `.agents/triage-states.md` - the `Status:` vocabulary
- `.agents/domain.md` - domain doc layout: `CONTEXT.md`, ADRs, glossary rules

All pipeline skills read these first and fall back to documented defaults when they are missing.
