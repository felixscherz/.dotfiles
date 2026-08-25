---
name: catch-up
description: Walk the user through changes they did not watch happen - after a batch-implement run, a ticket finished by another agent, or time away from a codebase - and review the changes against the feature's spec when one exists. Use when the user says "catch me up", "walk me through the changes", "what changed", "review the feature", "review ticket NN", or wants to get back in sync with a repo.
---

# Catch up

Re-sync the human with changes they did not watch happen, and review those changes against the spec that motivated them. This is the counterpart of `pair-program`: pairing keeps the shared model alive while the work happens; catch-up rebuilds it afterwards. The goal is the same - the human can answer "what changed and why" - and the review is a byproduct of getting there: a walkthrough the human actually follows is a review.

Communicate per the `unslop` skill: concrete, direct, pointing at real code.

## Scope the walkthrough

Establish what to cover before showing anything:

1. **A feature workspace** (`.agents/features/<feature>/`) - the common case after `batch-implement` or ticket pickups. Read the README, spec, every ticket, and any `summary-NN.md` files. Find the commits that implemented the tickets (closing notes, summaries, commit messages).
2. **A named target** - a ticket, branch, PR, or commit range the user points at.
3. **Time away** - no workspace, just a gap. Ask for the anchor ("since which commit / when were you last in sync?") and take the commits since.

State the scope in one sentence and confirm it before starting: "Covering tickets 01-04 of `<feature>`, 9 commits, against `spec.md`."

## Ground truth is the diff, not the summary

Summaries, closing notes, and commit messages are claims by the agent that wrote them. Read the actual diffs and, where behavior matters, the resulting code. When a summary and the diff disagree, the diff wins and the disagreement itself is a finding worth surfacing.

## The walkthrough loop

Walk one meaningful unit at a time - a ticket, or a coherent group of commits. For each unit:

1. **Orient.** What this unit set out to do, in one or two sentences, from the ticket or commit message.
2. **Show what actually changed.** Files touched, new or changed interfaces, the key diff hunks. Point at real code (`file:line`), not paraphrase.
3. **Name the decisions that were not in the brief.** Module layout, naming, dependencies added, patterns chosen, scope silently extended or dropped. These are exactly what erodes the human's mental model - never let them pass unnamed.
4. **Gauge against the spec** (when one exists). Which requirements this unit satisfies, where it diverges from the spec's contracts or constraints, whether a divergence looks deliberate or accidental.
5. **Pause.** Let the user dig into a diff, question a decision, or move on. Small units keep redirection cheap - the same rhythm as `pair-program`'s loop.

Do not dump the whole walkthrough in one message. The point is the human's understanding, and that is built unit by unit.

## Verdict

After the walkthrough, when a spec exists, close with a requirement-level assessment:

- Each numbered requirement: implemented, diverged (how), missing, or not verifiable.
- Each ticket marked `done`: do its acceptance criteria actually hold? Flag anything marked done that you could not verify.
- Contract-level checks: the spec's normative interfaces, schemas, and error behavior.

Without a spec, close with a plain summary of the state: what the changes add up to, what looks solid, what looks risky.

## Capture what falls out

- Bugs, gaps, and concerns found during the walkthrough: capture as issues via `triage` (capture is cheap; do not let findings evaporate into conversation).
- Divergences from the spec worth keeping: propose updating the spec or recording an ADR rather than leaving the spec lying.
- Append a dated note to the feature README: that this catch-up/review happened, its scope, and the outcome.

## Related

- `batch-implement` - produces the unreviewed changes this skill most often walks through.
- `to-spec` - produces the spec the review is gauged against.
- `triage` - captures the findings.
- `pair-program` - the during-the-work counterpart; this skill rebuilds the shared model after the fact.
- `ship-feature` - the pipeline's terminal stage; it follows this skill's walkthrough loop and then closes the feature's lifecycle with a pull request.
