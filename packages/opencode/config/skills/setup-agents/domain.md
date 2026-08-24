# Domain Docs

How agents should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root, or
- **`CONTEXT-MAP.md`** at the repo root if it exists (multi-context repos only) - it points at one `docs/<context>/CONTEXT.md` per context. Read each one relevant to the topic.
- **`docs/adrs/`** - read ADRs that touch the area you are about to work in.
- **`.agents/`** - agent-created and agent-addressed docs (the issue-tracker, triage-state, and domain config, plus any other notes agents wrote for future agents).

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. They are created lazily when terms or decisions actually get resolved - any session may create or update `CONTEXT.md` or an ADR the moment a domain term or decision lands.

## File structure

Agent-created and agent-consumed docs (issues, specs, tickets, and the agent config) live under a top-level `.agents/`. Human-facing documentation - `CONTEXT.md` and the ADRs - stays in the repo's normal doc locations, because those are for people as much as agents.

Single-context repo (most repos):

```
/
├── CONTEXT.md                       ← human + agent facing, stays put
├── .agents/                         ← agent-created and agent-consumed docs
│   ├── issue-tracker.md
│   ├── triage-states.md
│   ├── domain.md
│   ├── issues/                      ← tracked standalone issues
│   │   └── 01-<slug>.md
│   └── features/                    ← one directory per feature
│       └── <feature-name>/
│           ├── spec.md              ← the specification (from to-spec)
│           ├── ticket-01.md         ← ordered implementation tickets (from to-tickets)
│           └── summary-01.md        ← implementation summaries when generated
└── docs/
    └── adrs/                        ← human-facing decision records
        ├── 0001-<slug>.md
        └── 0002-<slug>.md
```

Multi-context repo (presence of `CONTEXT-MAP.md` at the root):

```
/
├── CONTEXT-MAP.md
├── .agents/                         ← system-wide agent docs
│   ├── ordering/                    ← context-scoped agent docs (issues, features, config)
│   └── billing/
└── docs/
    ├── adrs/                        ← system-wide decisions
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── adrs/                    ← context-scoped decisions
    └── billing/
        ├── CONTEXT.md
        └── adrs/
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `CONTEXT.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need is not in the glossary yet, that is a signal - either you are inventing language the project doesn't use (reconsider) or there is a real gap (propose adding the term to `CONTEXT.md`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (<title>) - but worth reopening because..._

## ADR conventions

- `docs/adrs/<NNNN>-<slug>.md` (or `docs/<context>/adrs/` in multi-context repos), numbered from `0001`, zero-padded to four digits
- Keep ADRs short: context, decision, consequences
- Never edit a settled ADR's decision - supersede it with a new ADR that links back to the old one
