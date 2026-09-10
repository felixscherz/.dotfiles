---
name: spacer
description: Operate the SPACER AI software factory through Search, Plan, Assert, Code, Evaluate, and Reconcile, with durable task artifacts and human signoff. Use to start or resume a SPACER task, run a named phase, reconcile findings, or prepare acceptance.
---

# SPACER

Turn an agreed task into an accepted result through evidence, corrective loops, and explicit human authority.
This skill defines an operating model. The user or harness may run phases in separate sessions and choose which
participants perform them. No particular runner, agent topology, or storage service is required.

## Design goals

- Give the human control of the intended outcome, consequential changes, and final acceptance.
- Allow autonomous investigation, implementation, and correction within the approved agreement.
- Give discoveries at every phase a defined route back into the work.
- Base readiness on evidence about the current agreement and work.
- Preserve task history while making the current agreement and next action easy to understand.
- Produce a handover that supports an informed acceptance decision.
- Keep the amount of documentation proportional to the task.

## Authority and completion

The human and AI establish the task definition together. The factory may decide how to satisfy that agreement within
the user's delegated authority. Changes to scope or acceptance criteria require human signoff. A clarification that
selects between materially different acceptable results is such a change, even if it is small.

A proposed amendment has no effect until approved. Preserve approved history and identify what each amendment
supersedes. Never amend requirements or weaken verification merely to make an implementation pass.

The factory can declare work ready for signoff. Only the human or an explicitly authorized external reviewer can
accept it. Record actual approval of identified work and an identified agreement. Preparing a brief, passing tests,
silence, and approval of a plan are not final acceptance. Acceptance does not itself authorize release or publication.

## Enter or resume a task

1. Identify the task artifact and requested phase or phases from the user's prompt. For a new task, begin with Search
   unless the user has supplied enough context and explicitly requests another phase.
2. Read [the artifact convention](references/artifacts.md), the task's current state, and the effective agreement.
   Follow links to the evidence, findings, and decisions relevant to this phase. Do not depend on an earlier chat.
3. Read the reference for each phase you will perform before performing it. Shared authority and routing rules here
   always apply. Phase detail is mandatory for the active phase; unrelated phase references need not be loaded.
4. State the phase, agreement revision, and intended output briefly. Check prerequisites against existing records.
   Honor recorded approvals without requesting them again. If prerequisites are missing, explain the gap and route
   to the needed responsibility; an instruction to start in Code does not establish missing scope approval.
5. Respect the user's session boundary. If asked to complete Assert only, produce its output and handoff. If asked
   to continue autonomously, follow the routes below within the approved scope and delegated authority.

If the user supplies findings without a phase, begin with reconciliation to select the next responsibility.
Treat an explicit phase choice as steering, while surfacing any inconsistent or missing prerequisites.

## Phases

| Phase | Responsibility | Reference |
|---|---|---|
| Search | Gather context, investigate assumptions, and explore the problem with the human | [Search](references/search.md) |
| Plan | Establish or revise the agreement, including observable acceptance criteria | [Plan](references/plan.md) |
| Assert | Establish credible verification before implementation | [Assert](references/assert.md) |
| Code | Produce and refine the implementation and other deliverables | [Code](references/code.md) |
| Evaluate | Assess the current work against the agreement and question verification adequacy | [Evaluate](references/evaluate.md) |
| Reconcile | Assess findings, route work, enforce authority boundaries, and arrange signoff | [Reconcile](references/reconcile.md) |

The normal progression is Search -> Plan -> Assert -> Code -> Evaluate -> Reconcile.
Reconciliation can be invoked from every phase. Do not continue known-invalid work just to reach the end of the sequence.

## Feedback and routing

Ordinary corrections stay within their phase, such as changing code after a failing test. Invoke reconciliation when
a discovery challenges an assumption, needs another phase's responsibility, or exceeds delegated authority.
Read [Reconcile](references/reconcile.md) when doing so, even within a Code session.

| What needs revision or resolution | Route |
|---|---|
| Missing facts or uncertain assumptions | Search |
| Ambiguous, conflicting, or changed agreement | Plan; obtain approval for scope or acceptance changes |
| Inadequate assertions or verification procedure | Assert |
| Defective implementation under a clear agreement | Code |
| Missing, incomplete, or stale assessment | Evaluate |
| Decision beyond delegated authority | Await the authorized decision |
| Supported agreement and resolved findings | Prepare signoff in Reconcile |

Return to the earliest responsibility whose output needs revision, then reconsider affected downstream work.
Preserve unaffected work. Record which assertions, evidence, or acceptance decisions became stale and why.

Route by the kind of decision and its authority, not by how quick a fix appears. A finding may need correction,
investigation, an amendment, justified dismissal, or a separate follow-up task. It does not automatically change
the agreement. Deferring a violated MUST to a follow-up does not satisfy it.

## Durable state and session boundaries

The task definition, approved amendments, verification, work product, evidence, findings, decisions, and signoff are
distinct concepts. [The artifact convention](references/artifacts.md) provides a small Markdown layout for this trial.
Create records as they become useful; do not create empty documents for every possible asset.

Track phase separately from lifecycle status: active, awaiting-decision, awaiting-signoff, accepted, or cancelled.
A phase can be waiting. A finished session does not imply an accepted task.

At each handoff, update durable state with the current agreement revision, work reference, phase and status, outputs,
unresolved findings or decisions, stale evidence, and recommended next action. Provide a short prompt the user can
paste into a fresh session. The prompt points to records rather than attempting to reproduce the chat history.

If repeated attempts produce no new evidence or progress, or an agreed operating limit is reached, record what was
tried and the decision needed. Pause affected work for that decision. Never infer success from an exhausted limit.
