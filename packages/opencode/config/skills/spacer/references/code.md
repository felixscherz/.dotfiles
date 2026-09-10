# Code

Produce the implementation and other agreed deliverables. Use the effective agreement and assertions to guide work.

## Inputs

Read the approved agreement, verification plan, current work, and findings requiring correction. Check that the
planned work is within scope and that the inputs are current.

## Work

Implement, run relevant checks, inspect results, and correct ordinary defects within this phase. Preserve unrelated
user work and follow project conventions. Record useful evidence and discoveries needed beyond the current session.
There is no need to log every transient edit or ordinary failing test as a finding.

Create findings for concerns that require assessment or handoff. Invoke reconciliation immediately when a discovery
invalidates continued work, requires another responsibility, or exceeds delegated authority. Other concerns can be
recorded while independent in-scope work continues.

If verification itself is defective, explain the issue and route through Assert. Updating a test to reflect a valid
implementation detail can be routine; changing its expected outcome so an unmet requirement passes is not.

## Local evaluation loops

When the user authorizes evaluation subagents and the harness supports them, give the evaluator the SPACER entrypoint,
Evaluate reference, effective agreement, work to inspect, and relevant evidence. State the scope of the assessment.
Use a fresh context where available. Let the evaluator inspect primary artifacts and identify its own findings.
Do not seed the assessment with a desired verdict or rely solely on the implementer's account.

Keep evaluation read-only with respect to implementation. The evaluator reports findings; Code makes corrections.
Avoid changing the work under an ongoing assessment, or explicitly identify changes that invalidate that assessment.
Record returned findings and evidence in the task's durable artifacts.

Use the shared reconciliation rules to disposition findings. Correct defects under a clear agreement locally and
obtain renewed evidence. Fix size is not an authority boundary: a tiny scope change requires signoff, while a large
in-scope defect need not. Preserve unresolved findings for the later reconciliation handoff.

A local review covers only its stated scope and work version. It replaces a separate final Evaluate session only if
its latest assessment covers the complete current result and effective agreement. Otherwise retain the partial
evidence and identify the remaining assessment.

## Exit and handoff

Record what changed, verification results, work reference, unresolved findings, and what evaluation remains.
Stop at the user's requested session boundary, or continue into Evaluate if authorized. Code completion is readiness
for assessment, not acceptance. Repeated correction without progress should return to reconciliation for a decision.
