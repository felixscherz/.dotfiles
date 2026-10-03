---
name: engineering
description: Use for any non-trivial code change - features, bug fixes, refactors, writing or changing tests, designing types, modules, or APIs, shipping the change through a pull request, and reviewing a pull request or code changes ("review this PR", "code review", "review my branch", a PR number or URL). Also when the user asks to follow my engineering principles.
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

## Start of a task

A codebase is a representation of a model, an abstraction of the real world.
The model does not have to mirror reality, it has to serve the problem. Think
in terms of the model first, then the code. Starting deep in the code risks
missing a wrong model, or chasing a local optimization when a global one is
available.

- Before changing code, understand the problem, the domain, and how the parts
  you are about to touch work together.
- While reading code, check whether it still supports the model or has drifted
  from it. Name any drift you find. When code and model disagree, decide which
  one is wrong before fixing either.
- Read the feature map at `.felixws/FEATURE_MAP.md` in the repository root
  before exploring the code. It is globally git-ignored, so read it by path.
- Find the workspace map with
  `references/workspace-map/find-workspace-map.sh <starting directory>`. It
  prints the map's path, or exits 1 when there is none. Read the map when the
  task may need context from outside the current repository.

## Principles

Each reference holds one rule, and the index says when it applies. Read a
reference when its trigger fires, not before: do not read ahead for phases you
have not reached, and do not batch-read references up front. Read a reference
in full before applying it. Do not list the rules you applied in your reply
unless the user asks.

- **Feature map** (`references/feature-map.md`). The feature map is missing
  or points to the wrong place, or a task adds, moves, renames, or removes a
  feature.
- **Workspace map** (`references/workspace-map/workspace-map.md`). The
  workspace map is missing or invalid, a task needs a repository, document, or
  directory outside the current working directory, or a mapped resource is
  added, moved, or removed.
- **Domain-driven design** (`references/domain-driven-design.md`). Naming or
  modelling domain concepts, adding a process that spans several services, or
  domain logic scattered across layers.
- **Redesign from first principles** (`references/redesign-from-first-principles.md`).
  Requirements change or are added, a drift is found, or you are about to add
  a special case for an edge case.
- **Deliver in small steps** (`references/deliver-in-small-steps.md`). Deciding
  how much to build for a request, when a fix suggests a larger redesign, or
  planning work that spans several changes.
- **Program design** (`references/program-design.md`). Designing a new module,
  API, or model, deciding where code lives, or code that is hard to test.
- **Type system** (`references/type-system.md`). Designing types, signatures, or
  data shapes, or reaching for a plain string, dict, or bool that carries
  meaning.
- **Python** (`references/python/INDEX.md`). Writing or changing Python code.
  The index lists the Python references and when each applies; read only the
  ones the task needs.
- **Lifecycle hygiene** (`references/lifecycle-hygiene.md`). Writing or
  changing a long-running service or worker: startup, shutdown, background
  tasks, consumers, readiness probes, or dependencies that can go away.
- **Test-driven design** (`references/test-driven-design.md`). Before
  implementing a feature or fixing a bug.
- **Find the root cause** (`references/find-the-root-cause.md`). When debugging
  a failure or investigating a bug, before choosing a fix.
- **Test behavior** (`references/test-behavior.md`). Writing, changing, naming,
  or keeping a test, or about to reach for a mock or patch.
- **Never make the same mistake twice** (`references/never-make-the-same-mistake-twice.md`).
  After finding a bug, misusing a third-party API, or discovering a wrong
  assumption about an external service or constraint.
- **Don't break production** (`references/dont-break-production.md`). A
  change alters behavior that callers, users, or other systems can observe,
  including invisible semantics like durability, retries, ordering, or
  error handling where the interface stays the same.
- **Ship changes** (`references/ship-changes/ship-changes.md`). A change is
  done and needs to be committed, pushed, and integrated through a pull
  request, or a PR description needs writing or updating.
- **Code review** (`references/code-review.md`). Reviewing a pull request or a
  set of code changes, your own or someone else's.

## Maintaining this skill

These rules are a living draft, not a finished standard. Be critical of them.
When one gets in the way, leads to a worse result, misses a situation, or
contradicts another rule or the codebase, say so at the end of your reply. The
user decides when the skill changes: never edit it unprompted. Changes go
through the `reflect-on-engineering` skill
(`../reflect-on-engineering/SKILL.md`), which also holds the conventions for
editing this skill.
