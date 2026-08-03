# Domain Docs

How agents should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root, or
- **`CONTEXT-MAP.md`** at the repo root if it exists - it points at one `docs/<context>/CONTEXT.md` per context. Read each one relevant to the topic.
- **`docs/adrs/`** - read ADRs that touch the area you are about to work in. In multi-context repos, also check `docs/<context>/adrs/` for context-scoped decisions.
- **`docs/agents/`** - agent-created and agent-addressed docs (the issue-tracker, triage-state, and domain config, plus any other notes agents wrote for future agents). In multi-context repos, `docs/<context>/agents/` holds context-scoped agent docs.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. They are created lazily when terms or decisions actually get resolved - any session may create or update `CONTEXT.md` or an ADR the moment a domain term or decision lands.

## File structure

Single-context repo (most repos):

```
/
├── CONTEXT.md
└── docs/
    ├── agents/                      ← agent-created and agent-addressed docs
    │   ├── issue-tracker.md
    │   ├── triage-states.md
    │   └── domain.md
    └── adrs/
        ├── 0001-<slug>.md
        └── 0002-<slug>.md
```

Multi-context repo (presence of `CONTEXT-MAP.md` at the root):

```
/
├── CONTEXT-MAP.md
└── docs/
    ├── agents/                      ← system-wide agent docs
    ├── adrs/                        ← system-wide decisions
    ├── ordering/
    │   ├── CONTEXT.md
    │   ├── agents/                  ← context-scoped agent docs
    │   └── adrs/                    ← context-scoped decisions
    └── billing/
        ├── CONTEXT.md
        ├── agents/
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
