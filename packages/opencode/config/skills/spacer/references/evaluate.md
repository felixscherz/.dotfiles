# Evaluate

Assess the actual work against the effective agreement and applicable quality expectations. Evaluate reports what
the evidence supports, what remains uncertain, and what needs attention.

## Inputs

Read the effective agreement and its revision, current work, verification plan and results, prior findings, and any
requested assessment scope. Inspect primary artifacts rather than accepting the implementation summary as proof.

## Work

Compare delivered behavior and scope with the agreement. Run or inspect appropriate checks and assess whether they
would detect meaningful failures. Check important interactions in the integrated result, not only isolated changes.
Consider whether a shared mistaken assumption could have shaped the requirements, tests, and implementation.

Evaluate against stated project quality expectations. Explain the basis and impact of additional concerns; a reviewer
preference or optional improvement does not automatically become a task requirement. If the agreement appears unable
to achieve the stated purpose, raise that as a finding for reconciliation rather than silently changing the target.

For each finding, state the observation, supporting evidence or uncertainty, relevant obligation, and impact.
Distinguish a demonstrated defect from a hypothesis requiring investigation. Check claimed fixes against evidence
before considering previous findings resolved.

Do not modify the implementation during evaluation. Return corrections to Code, verification deficiencies to Assert,
and agreement concerns through Reconcile. Evaluation may execute checks and write assessment records.

## Exit and handoff

Record the agreement revision and work assessed, assessment scope, evidence, finding IDs, and verification gaps.
Use a clear assessment such as supported, changes required, or inconclusive, explaining any limits.

An assessment supports readiness only to the extent of its coverage. Missing manual results remain missing evidence.
No findings does not prove success if the assessment is incomplete. Hand the report to Reconcile even when it finds
no issues; the factory still needs an informed acceptance decision.
