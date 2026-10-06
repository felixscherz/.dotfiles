# Preparation and planning

Plan with the user in a single pre-execution session. The output should let a fresh Orchestrator run the Saga and
fresh Workers complete their assignments without reconstructing the planning conversation.

## Define the Saga

- Agree on the goal, completion criteria, scope, non-goals, and decisions that remain with the user.
- Understand the affected system and dependencies. Use scoped research tasks when delegation is authorized; their
  results inform the plan and do not authorize implementation.
- Record behavior and other invariants that must hold throughout execution, not just in the final state.
- Record execution permissions, including whether commits, pushes, PRs, or other external changes are authorized.
  Planning permission alone is not permission to execute or ship.

## Divide it into Episodes

- Give each Episode one coherent outcome, dependencies, boundaries, and concrete acceptance criteria.
- Include the integration points necessary for the outcome. Scope is not just a list of files: say which behavior
  may change and which must remain intact.
- For staged changes, distinguish adding a replacement, activating it, and removing the old path. State which
  Episode owns each transition. Every intermediate state should satisfy the Saga's preserved invariants.
- Name ownership of shared changes so Workers do not independently make conflicting edits or each leave the same
  integration work to someone else.
- Separate implementation Episodes from supporting tasks such as repository preparation, review, or diagnosis.
- Default to sequential Episodes. Only plan parallel work when dependencies and writable workspaces are independent
  and that execution model is agreed with the user.

## Prepare the handoff documents

Use existing document names when the user supplied a plan. Otherwise these are useful defaults in the Saga workspace:

- `SAGA_PLAN.md`: goal, approved design, scope, preserved invariants, ordered Episodes and dependencies, verification,
  execution permissions, and open decisions.
- `episodes/<episode-id>.md`: the Episode outcome, relevant plan sections, prerequisites, permitted changes,
  exclusions, preserved invariants, verification, and deliverables.
- `RUN_STATE.md`: initially mark the Saga as planned, with its starting repository/revision or other baseline and
  any prerequisites still outstanding. The Orchestrator will maintain this during execution.

Keep shared constraints in the Saga plan and reference them from Episode briefs. Make the constraints critical to a
particular Episode explicit in its brief rather than relying on the Worker to infer them from the final design.

Close the planning session with the document paths, unresolved decisions, and whether the Saga is ready to run.
Do not imply that planning completed any Episodes. The user can start a separate Orchestrator session from this
handoff; the planning agent does not have to be the later Orchestrator.
