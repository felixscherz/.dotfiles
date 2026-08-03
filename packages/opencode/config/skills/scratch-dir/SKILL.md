---
name: scratch-dir
description: Where to put throwaway agent-generated files so they do not pollute the repo. Use whenever you need to write a file that is not part of the project source - one-off scripts, captured logs, experiment output, drafts. Put them in a `.scratch/` directory at the repo root. Durable agent docs (specs, issues, handoffs) go under `docs/agents/` instead - see the `setup-agents` skill.
---

# Scratch dir

Throwaway agent-generated files go in `.scratch/` at the repository root,
never scattered through tracked directories.

Durable, agent-addressed documentation is different: specs, issues, and
handoff docs live under `docs/agents/` (or `docs/<context>/agents/` in a
multi-context repo) so they are tracked and visible in editor autocomplete.
See the `setup-agents`, `to-spec`, `to-tickets`, `triage`, and `handoff`
skills. `.scratch/` is only for the disposable stuff below.

## What belongs in `.scratch/`

- One-off scripts you only need as a file (probes, parsers, reproductions,
  data fixups)
- Captured logs, experiment output, generated samples
- Rough drafts and working notes you are still iterating on

## What does not belong there

- Anything durable or addressed to another agent: source, tests, ADRs,
  config, and the agent docs above. Specs, issues, and handoffs go under
  `docs/agents/`; code, tests, and config go to their proper repo location.
- Secrets or credentials.

## Rules

1. **Location:** `<repo-root>/.scratch/`. Repo root is
   `git rev-parse --show-toplevel`; if not a git repo, use the current
   working directory.
2. **Create on demand:** `mkdir -p .scratch` the first time you need it.
3. **Keep it out of git:**
   - Check `git check-ignore .scratch` first; the user's global gitignore
     already covers it.
   - If it is not ignored, append `.scratch/` to `.git/info/exclude`
     (repo-local, leaves tracked files untouched). Only edit the repo's
     `.gitignore` if the user asks.
4. **Never commit** files from `.scratch/`, and never copy them into tracked
   paths unless the user asks. If something in scratch turns out to be worth
   keeping, move it to its proper repo location instead.
5. **Name files descriptively**, date-prefixed when useful:
   `2026-07-31-plan-auth-refactor.md`, `repro-nil-deref.py`.
6. **Disposable:** contents may be left behind (ignored anyway) or deleted
   once stale. Do not delete files you did not create without asking.
7. **Reference scratch files by path** when you mention them, so the user can
   find them.
