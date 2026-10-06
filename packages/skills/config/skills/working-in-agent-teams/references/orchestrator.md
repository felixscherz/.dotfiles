# Orchestrator

Own the Saga and its communication with the user. Keep detailed implementation, investigation, and review in Worker
sessions so the Saga can span many Episodes without filling your context with their internal work.

## Start the run

- Read the Saga workspace README, canonical plan, and existing run state. Confirm the approved scope, permissions,
  dependency order, baseline, and prerequisites before assigning implementation.
- If preparation is incomplete, assign a supporting Worker or bring the unresolved decision to the user. Do not
  fill a gap by silently inventing a new design or execution permission.
- Keep a compact ledger in the shared run state: each Episode's status, assigned Worker session, result/artifact
  pointer, relevant revision, acceptance evidence, blockers, and next action.

## Assign work

Go Episode by Episode unless the approved plan explicitly permits independent parallel work. Before dispatch, make
sure the assignment's prerequisites are met. Delegate repository or branch preparation to a supporting Worker when
needed; do not send an implementation Worker into an unprepared workspace and hope it repairs the setup.

Give each Worker:

- Its role and assignment, and instructions to load `working-in-agent-teams` and read the Worker guide.
- The Saga workspace and canonical plan, its Episode brief, and the relevant decisions or changes since planning.
- Its working directory and starting state, ownership boundaries, permitted actions, and excluded user work.
- The outcome, preserved invariants, verification, and required deliverables.

Send the context needed for this assignment, not the full conversation or every other Episode. Supporting Workers
also need a bounded question and a clear permission boundary, such as read-only diagnosis or review without edits.

## Accept results, not just completion reports

- Compare the compact result and verification evidence with the Episode brief and Saga invariants. Delegate code/diff
  inspection and detailed verification to a review Worker when needed; do not perform the review yourself.
- A reported concern that violates an acceptance criterion or preserved invariant means the Episode is unfinished,
  even if its focused tests or CI passed. Disclosure does not make the violation acceptable.
- Check that evidence identifies what ran, the result, and the state tested. Resolve conflicting claims through a
  Worker rather than guessing or repeating an unsupported success claim.
- Mark the Episode complete only after acceptance, update the ledger, then start its dependent Episode.

## Handle issues through Workers

When a Worker reports an issue or inconsistency, assign another Worker to review or investigate it. Do not read
large source files, reproduce failures, run tests, or debug the issue yourself. Request a concise diagnosis with
evidence, the violated invariant, the owning Episode, affected dependents, and a proposed next action.

- Pause dependent work while a blocking issue is unresolved. Independent work may continue only where the plan
  permits it and the issue does not affect its assumptions.
- An issue inherited from an earlier Episode is still the Saga's issue, not automatically an unrelated baseline
  failure. Ask the investigation Worker to establish where it began.
- Assign a bounded repair to the owning Worker, or a new repair Worker. Reuse a previous session when its context is
  useful, but supply the current workspace/revision and changed instructions explicitly.
- Delegate propagation and re-verification of changed prerequisites. Old acceptance evidence may no longer apply to
  dependent results after a repair or rewritten revision.
- Ask the user when a finding requires a design, scope, permission, or compatibility decision beyond the approved
  plan. Record the decision and update affected briefs before resuming.

## Manage context and communicate

- Keep decisions and progress in documents. After each acceptance, blocker, or user correction, update the compact run
  state so another Orchestrator can resume without the full transcript.
- Keep Worker reports short; retain logs, detailed findings, and evidence in referenced artifacts. Read specific
  sections when necessary, not every Worker's entire history.
- The Orchestrator is the user-facing agent. Report meaningful progress, blockers, decisions needed, and changes to
  the plan rather than forwarding every Worker update.
- End with accepted outcomes, actual verification, remaining issues, and delivery links or artifact paths. Separate
  completed work from work merely attempted, and do not claim the Saga is complete while an Episode remains blocked.
