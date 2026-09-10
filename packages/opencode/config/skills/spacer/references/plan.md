# Plan

Establish what the factory is authorized to deliver and how the result will be accepted. Plan produces an agreement,
not a file-by-file implementation recipe.

## Inputs

Read Search context or the effective agreement, originating findings, and reconciliation decisions for a revision.
Identify which decisions the user has already made and which remain open.

## Work

Create a task definition with these sections where relevant:

- Problem, intended outcome, and context.
- Scope and non-goals.
- Numbered requirements and observable acceptance criteria.
- Constraints and applicable quality expectations, including links to standing project policies.
- Design decisions that constrain the result, their rationale, and implementation freedom.
- Verification approach, including expected human or external participation.
- Delegated authority, acceptance reviewer, and any agreed operating limits.
- Assumptions, unresolved decisions, and agreement approval.

Use MUST and MUST NOT for mandatory requirements and prohibitions, SHOULD and SHOULD NOT for obligations allowing
reasoned exceptions, and MAY for permitted options. Adopt the uppercase meanings in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) and [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174).
Record justified SHOULD exceptions and obtain approval when their consequences change scope or acceptance criteria.
MAY permits an option within the task; it does not authorize unrelated work.

Label explanatory examples and suggested implementation approaches so they do not accidentally become requirements.
Make outcomes sufficiently observable for Assert to design credible verification. Resolve consequential ambiguity
with the human; avoid turning incidental implementation preferences into acceptance gates.

For an existing agreement, prepare an amendment with the exact proposed change, reason, alternatives where material,
and consequences for completed work and verification. Preserve the baseline and previous approved amendments.
Scope or acceptance changes, including consequential clarifications, require human signoff before taking effect.

## Exit and handoff

Record the approved definition or amendment and its revision. Existing explicit approval is sufficient; do not ask
for it again. If a required decision is missing, record the proposal and set the task to awaiting-decision.

After approval, refresh the effective agreement and identify affected downstream work. The normal next phase is
Assert, which establishes or revises verification. Do not claim earlier evidence supports changed obligations
without assessing whether it still applies.
