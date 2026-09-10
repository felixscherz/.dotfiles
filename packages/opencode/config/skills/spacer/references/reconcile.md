# Reconcile

Determine what should happen next and whether the factory has authority to proceed. Reconciliation is available
from every phase, including during a local Code/Evaluate loop.

## Inputs and decisions

Read the effective agreement, current state, relevant findings and evidence, prior decisions, and delegated authority.
For a local reconciliation, assess the triggering findings. Before final signoff, account for the complete task.

Determine what each finding means before choosing a route. Use the shared routing table in SKILL.md. Distinguish
implementation defects, inadequate verification, missing information, agreement changes, and optional follow-ups.
Record the disposition, reason, authority, next responsibility, and affected downstream work.

The factory may correct work within the approved agreement. For scope or acceptance changes, route to Plan to prepare
a concrete amendment for human approval. A proposed amendment has no effect until that approval is recorded.
If rejected, keep the current agreement and find another approach or explain why work cannot proceed.

Dismiss a finding only with justification. Defer it only when the current agreement remains satisfied and delegation
permits the decision. Otherwise obtain a human decision. A deferred mandatory failure is still a mandatory failure
unless the human approves a change to that obligation.

Independent work may continue while a decision is pending if it remains valid under the approved agreement and the
user's session scope permits it. Do not implement a pending amendment in anticipation of approval.

## Readiness for signoff

Check that the current agreement has adequate supporting evidence, evaluation covers the current complete work,
findings have justified dispositions, and no unresolved obligation prevents acceptance.

If a manual check remains, a draft signoff brief may help the human perform it. Record readiness as pending and obtain
the result before claiming the task is ready for acceptance. Missing evidence cannot become a pass through silence.

Prepare a signoff brief proportional to the task:

- Requested outcome and approved amendments.
- What was delivered, with concrete behavior changes and useful pointers to inspect or exercise it.
- Evidence supporting acceptance and its limits.
- Known limitations, dispositions of findings, and proposed follow-ups.
- Any checks or decisions still needed from the reviewer.
- The agreement revision and work version the reviewer is being asked to accept.

The brief must support understanding without requiring the reviewer to reconstruct the working history. A fresh
session can prepare it from task records, but must resolve stale or missing assessment before asserting readiness.
Set status to awaiting-signoff when the readiness conditions hold. Do not infer approval from producing the brief.

## Reviewer response

| Response | Action |
|---|---|
| Accept identified work and agreement | Record the actual decision and mark accepted |
| Request correction under the existing agreement | Record findings and route to the responsible phase |
| Request changed scope or acceptance criteria | Route to Plan for an amendment and approval |
| Request explanation or evidence | Improve the brief or obtain the missing assessment |

Only the human or an explicitly authorized external reviewer can grant final acceptance. An external automated check
alone does not establish the human understanding required by this workflow. If using external signoff, identify its
authority and how the human receives the account of the delivered work.

Preserve approval history. If later changes affect accepted behavior, requirements, or the basis of acceptance,
invalidate the affected assessment and signoff, return to active work, and obtain renewed acceptance of the changed
result. Explain why any retained evidence still applies. Acceptance does not itself authorize deployment or publishing.

## When the loop cannot progress

If attempts repeat without new evidence or progress, or an agreed operating limit is reached, describe the unresolved
issue, approaches tried, available alternatives, and recommendation. Request the decision needed to investigate,
revise, pause, or cancel. Record awaiting-decision; cancellation requires an authorized decision. A stopped session,
resource limit, or unresolved dependency never means accepted.
