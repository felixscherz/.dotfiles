# Artifact convention

Use the task location supplied by the user or an established repository convention. If neither exists, use
`spacer/tasks/<task-slug>/` as the trial default and state the chosen location. This is a storage default, not part of
the operating model. Do not introduce a runner, tracker, or repository migration to operate this skill.

## Trial layout

| File | Contents | Create when |
|---|---|---|
| `task.md` | Context, original task definition, and its approval | Search or Plan needs a durable record |
| `state.md` | Current phase, status, revisions, artifact index, and next action | First session handoff |
| `amendments.md` | Proposals, their decisions, and approved agreement changes | A change is proposed |
| `verification.md` | Verification plan, assertions, evidence, and evaluation reports | Assert begins |
| `findings.md` | Findings, dispositions, and reconciliation decisions | A finding needs a durable record |
| `signoff.md` | Signoff brief and actual acceptance decisions | Preparing final signoff |

The implementation remains in its normal project location. Link to larger evidence or deliverables instead of copying
them into these files. If existing records already serve these purposes, map them in `state.md` and reuse them.

## Agreement and revision history

Use stable requirement IDs such as R1 and R2. Keep the original approved task definition as the baseline. Before
approval, a draft can be edited normally. After approval, preserve it and record agreement changes as amendments.

An amendment identifies its ID, base revision, motivation or originating findings, exact changes to requirements,
what it supersedes, consequences, and approval status. Record the human's actual decision and the resulting revision
when approved. A pending or rejected proposal has no effect. Conflicting proposals need resolution before application.

Maintain a current effective agreement in `state.md`, or link to one maintained alongside it if it is substantial.
It must present the operative requirements clearly, incorporating only approved amendments and identifying the
baseline and amendments used. This view summarizes authoritative history; it cannot introduce new obligations.
When it disagrees with that history, reconcile the discrepancy before relying on it.

## State and handoff

Use these fields as a compact starting point, adjusting presentation to the task:

```markdown
# Task state

Task definition: task.md
Phase: Search
Status: active
Agreement revision: draft
Agreement approval: not yet approved
Work reference: no implementation yet

## Effective agreement

Baseline and approved amendments, with the current operative requirements or a link to that view.

## Artifacts and current assessment

Links to existing verification, findings, amendments, and signoff records.
Which assessment covers the current work; what remains unverified or became stale.

## Next action

Recommended phase, reason, prerequisites, and unresolved decisions.

## Session handoff

What this session produced and what the next session should read and do.
```

Record enough of the work version to distinguish what was assessed. Use repository revisions when available and
account for uncommitted changes; a commit ID alone does not identify a dirty worktree. Other environments can use an
artifact version or saved snapshot. Do not invent precision or create a commit solely to fill this field.

## Verification and evidence

Link each acceptance obligation to how it will be assessed. Record expected results and material limits of each check.
Manual checks identify who can perform them, the procedure, and the expected observation.

Evidence records the check performed, actual result, relevant conditions, work reference, agreement revision, and
where supporting output can be found. Distinguish passed, failed, not run, and inconclusive results. A manual test
plan is not evidence of a successful manual test.

Keep prior evaluation reports as history. Each report identifies the agreement and work assessed, evidence used,
coverage gaps, and finding IDs. When work or requirements change, identify the affected evidence that needs renewal.

## Findings and decisions

Give each finding a stable ID such as F1. Record its observation, evidence or uncertainty, relevant requirement or
quality expectation, impact, and originating phase. An observation is not automatically a confirmed defect.

Append decisions with their rationale and authority. Useful dispositions include correction required, investigation
required, amendment proposed, resolved with evidence, dismissed with justification, and deferred to a linked follow-up.
These labels are a vocabulary, not a second mandatory state machine.

A fix is not verified merely because the implementer reports it complete. Link the evidence that resolves the finding.
Preserve earlier observations and decisions when a finding is reopened or its interpretation changes.

Defer work only within delegated authority. Explain why the current agreement remains satisfied. Record a follow-up
locally if creating an external ticket is not authorized; do not silently discard the concern or publish a ticket.

## Signoff

The brief presents the case for acceptance; the decision records what the reviewer actually approved or rejected.
Both refer to the effective agreement and work version. Record reviewer identity, date, decision, and any conditions
or requested changes. Retain enough context from the approval to establish its scope without fabricating consent.

## Fresh-session prompts

These are examples of handoffs, not commands required by a particular harness:

- "Use SPACER. Start with Search, then Plan with me. Save the task in `<task-directory>`."
- "Use SPACER in Assert for `<task-directory>/task.md`. Read its sibling `state.md`. Stop after the handoff."
- "Use SPACER in Code for `<task-directory>/task.md`. You may use evaluation subagents for local correction."
- "Use SPACER to Evaluate the current task at `<task-directory>/task.md`."
- "Use SPACER to Reconcile findings for `<task-directory>/task.md` and recommend the next phase."
- "Use SPACER to prepare the signoff brief for `<task-directory>/task.md` and walk me through it."
