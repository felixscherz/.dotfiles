---
name: engineering
description: Use for any non-trivial code change - features, bug fixes, refactors, writing or changing tests, designing types, modules, or APIs. Also when the user asks to follow my engineering principles.
---

# Engineering

## Know when rules do not apply

These rules are my personal defaults, not my team's. Where a codebase has
established conventions, the conventions win. Where it has none, the rules
apply in full.

- Follow the patterns the codebase already uses, even where a rule here says
  otherwise. Personal preference is not a reason to impose a pattern on others.
- Look at how neighboring code solves the same problem before choosing an
  approach.
- Never make broad changes unprompted. Swapping a framework, a sweeping
  refactor, or a new architectural pattern needs the user's go-ahead.
- Pushing the boundary is sometimes right. When a convention causes a real
  problem for the task, propose the change with the reason and let the user
  decide.

## Principles

Each reference holds one rule, and the index says when it applies. Read a
reference in full before applying it. In your reply, name each rule you
applied and the decision it changed.

- **World building** (`references/world-building.md`). At the start of a task,
  and whenever requirements change or are added.
- **Feature map** (`references/feature-map.md`). At the start of a task,
  when looking for where a feature lives, and after adding, moving, renaming,
  or removing a feature.
- **Workspace map** (`references/workspace-map/workspace-map.md`). At the
  start of a task, when a task needs a repository, document, or directory
  outside the current working directory, and after a mapped resource is added,
  moved, or removed.
- **Domain-driven design** (`references/domain-driven-design.md`). Naming or
  modelling domain concepts, adding a process that spans several services, or
  domain logic scattered across layers.
- **Redesign from first principles** (`references/redesign-from-first-principles.md`).
  Requirements change or are added, a drift is found, or you are about to add
  a special case for an edge case.
- **Program design** (`references/program-design.md`). Designing a new module,
  API, or model, deciding where code lives, or code that is hard to test.
- **Type system** (`references/type-system.md`). Designing types, signatures, or
  data shapes, or reaching for a plain string, dict, or bool that carries
  meaning.
- **FastAPI applications** (`references/python/fastapi-applications.md`). Designing
  or changing FastAPI routes, dependencies, domain boundaries, or app wiring.
- **Test-driven design** (`references/test-driven-design.md`). Before
  implementing a feature or fixing a bug.
- **Test behavior** (`references/test-behavior.md`). Writing, changing, naming,
  or keeping a test, or about to reach for a mock or patch.
- **Never make the same mistake twice** (`references/never-make-the-same-mistake-twice.md`).
  After finding a bug, misusing a third-party API, or discovering a wrong
  assumption about an external service or constraint.

## Maintaining this skill

- **Keep engineering up to date** (`references/keep-engineering-up-to-date.md`).
  A rule here proves wrong, outdated, or missing, or the user asks to update
  this skill.
