---
name: ship-feature
description: Final sign-off after batch-implement - review the implemented feature against its spec, surface drift and what the implementation revealed, close the feature's lifecycle, and produce a pull request ready for human review. Use when the user says "ship the feature", "ship it", "review against the spec", "sign off on the feature", "final review", or wants a PR created after the tickets are done.
disable-model-invocation: true
---

# Ship feature

The terminal stage of the delivery pipeline. Tickets are done, agents have committed; nothing has been checked by a human. This skill does three things, in order: rebuild the user's mental model of what was actually built (drift from the spec, decisions the spec left open, what implementation revealed), close the feature's lifecycle, and produce a pull request ready for review by humans and other agents.

Hold the goal of shipping throughout. The review is the means; the PR is the end. Every finding either blocks the ship or becomes a tracked follow-up - never a vague concern left in conversation.

Communicate per the `unslop` skill.

## Configuration

Read the repo config first, as the other pipeline skills do:

- `.agents/issue-tracker.md` - where issues and feature workspaces live.
- `.agents/triage-states.md` - the `Status:` vocabulary.
- `.agents/domain.md` - context docs and ADR conventions for the area touched.

If missing, use the pipeline defaults and mention `setup-agents` once.

## Process

### 1. Establish ground truth

Locate the feature workspace `.agents/features/<feature>/` and read everything: README, `spec.md`, every `ticket-NN.md`, every `summary-NN.md`, `progress.json`. Identify the commits the implementation produced (closing notes, summaries, `git log` since the feature started).

Then set the claims aside. Ticket `Status: done`, closing notes, and summaries were written by the agents being reviewed - they are claims, not evidence. The diffs and the resulting code are ground truth. Where a summary and the diff disagree, the diff wins and the disagreement is itself a finding.

Note anything unfinished up front: tickets in `error` or not `done`, gaps in `progress.json`. An incomplete run can still be reviewed, but the user decides whether to ship a partial feature.

### 2. Verify independently

Re-run the spec's Verification section yourself: the test suite, the acceptance criteria seams, any manual checks the spec called for. Do not take verification results from closing notes. A green run is a precondition for the PR; a red one is a blocking finding.

### 3. Walk the tickets

Walk the implementation with the user following the `catch-up` loop, scoped to this feature: one ticket (or coherent commit group) at a time - orient, show the real diffs, name the decisions that were not in the brief, gauge against the spec, pause. Check each ticket's acceptance criteria against the code, not the closing note.

If the user has already caught up (a recent catch-up note in the feature README, or they say so), compress this to a delta: only the units they have not seen.

### 4. Review the bigger picture

The user has the spec in their head; that is what they handed to the agents. This step reconciles their mental model with what exists.

Start from the requirement-level verdict as `catch-up` defines it: each requirement implemented, diverged (how, and does the divergence look deliberate or accidental), missing, or not verifiable, with the spec's normative contracts - interfaces, schemas, error behavior - checked directly against the code. If a recent catch-up already produced this verdict, reuse it and re-check only the units it did not cover; do not redo it from scratch.

Consolidate the open decisions the walkthrough named: everything the spec deliberately or accidentally left open - naming, module layout, dependencies added, patterns chosen. These are the details the user could not have in their mental model; gather them into one list, because they feed the PR description directly.

Then add the two lenses that belong to shipping:

- **What implementation revealed about the spec.** Places where the spec turned out wrong or incomplete once development started: an API that was not available, a design that conflicted with existing code, a requirement that forced unrelated changes. These are findings about the spec, not just the code.
- **Unexpected surface area.** Compare the set of files and modules actually touched against the footprint the spec's Current System section and the tickets imply. Changes outside that footprint are the concrete signal of a blindspot - an existing feature the user forgot, a design philosophy they were unaware of, or scope silently extended. Flag each with why the implementation went there.

### 5. Triage every finding

Give each finding from steps 2-4 exactly one fate, decided with the user:

- **Blocks the ship** - fix it now, before the PR. Failed verification, broken contracts, accidental drift that changes behavior.
- **Ships as known follow-up** - capture it as an issue via `triage` and reference it in the PR description. Deliberate drift, discovered tech debt, spec gaps that do not affect this feature's correctness.

If the run was partial - tickets in `error` or never started - and the user chooses to ship anyway, give the remainder the same treatment: each unfinished ticket becomes a tracked follow-up (or the spec's scope is trimmed to match what shipped), and the PR description says the feature ships partial and what is missing.

Then reconcile the record so nothing lies:

- Tickets whose `Status: done` did not survive verification: flip the status back (per the repo's `triage-states` vocabulary) and append a dated note saying what failed. A ticket must not claim done when its acceptance criteria do not hold.
- Divergences that are staying: update `spec.md` to match reality, or record an ADR when the divergence is an architectural decision.
- Realizations about how the spec-writing itself went wrong (a question `to-spec` should have asked, a context doc that was missing): route through `record-learnings`.

### 6. Prepare the pull request

Get the branch into shippable shape:

- Work must be on a feature branch. If the commits landed on the default branch, create a branch for them before anything else.
- Rebase or merge up to date with the default branch; resolve conflicts with the user. If the base moved, re-run the spec's verification afterwards - the green run from step 2 is stale once the branch is rebased, and a semantic conflict can slip through a clean rebase.
- Sweep for leftovers: debug code, stray files, commits unrelated to the feature. Decide with the user whether the `.agents/` workspace changes ship in this PR or separately - `agents-folder-conventions` supplies the default: in repos that have not adopted the structure, the workspace stays uncommitted. `implement.sh` and `progress.json` are batch-implement scaffolding - they do not ship unless the repo tracks them deliberately.

Write the PR description per `unslop`, for the reviewer who was not in the room:

- What the feature does and a link to `spec.md`.
- **Deviations from the spec, called out explicitly** - the honest reviewer-facing version of step 4. A reviewer holding the spec must not discover drift themselves.
- Decisions the spec left open and how they were resolved.
- How it was verified - what you ran in step 2, not what the ticket agents claimed.
- Where to look closely: the risky diffs, the unexpected surface area.
- Known follow-ups, linked to their tracked issues.

### 7. Ship and close the lifecycle

Run the shipping checklist with the user, then act on it:

- [ ] All blocking findings fixed and verification green on the final rebased branch
- [ ] Every non-blocking finding (including unfinished tickets, when shipping partial) captured as a `triage` issue
- [ ] Spec updated or ADRs recorded for divergences that stayed
- [ ] Ticket statuses and notes match what was actually verified
- [ ] Branch clean, rebased, leftovers swept
- [ ] PR created with the description above
- [ ] Source issues listed in the spec's Source Issues section moved to `done`, each with a dated note pointing at the PR
- [ ] Feature README updated: status "shipped" (or "shipped with follow-ups"), a dated note with the review outcome, the PR link, and the follow-up issues

Closing the source issues is this skill's job: `to-spec` leaves them open with a "folded into" note, and they close only when the feature actually ships - that is now.

Creating the PR is an outward-facing action: confirm with the user before pushing and opening it.

## Related

- `batch-implement` - produces the implemented, unreviewed feature this skill signs off on.
- `catch-up` - owns the walkthrough loop step 3 follows; use it standalone for mid-flight reviews or time away.
- `to-spec` - produces the spec this review is gauged against; drift that stays flows back into it.
- `triage` - captures follow-up findings and holds the source issues this skill closes.
- `record-learnings` - receives realizations about the spec-writing process itself.
- `unslop` - governs the PR description and all reviewer-facing prose.
- `agents-folder-conventions` - whether workspace changes may ship, and whether the PR description may link `.agents/` paths at all.
