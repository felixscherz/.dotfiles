# Assert

Establish how the factory and reviewer can tell whether an implementation satisfies the effective agreement.
This phase may write tests, design experiments, or prepare a manual verification procedure.

## Inputs

Read the approved effective agreement, relevant project checks, existing verification, and findings routed here.
The agreement defines success. Assertions must not silently narrow it to what is convenient to test.

## Work

Map applicable requirements and quality expectations to checks with observable expected results. Include important
negative behavior and boundaries implied by the agreement. Explain what each check establishes and what it cannot.

Use TDD when it provides useful evidence. Where meaningful, establish that a new test fails for the missing behavior
before implementation. Do not require artificial failing tests for documentation, exploratory work, or outcomes that
need another form of assessment. Reuse suitable existing checks.

For manual checks, provide prerequisites, actions, expected observations, and the person or role needed to perform
them. Identify unavailable environments or external dependencies. A procedure can be ready while its execution
remains pending; make that distinction visible.

Keep verification proportional to risk and the task. Avoid checks that merely restate implementation choices without
testing the required outcome. If success cannot be assessed credibly, create a finding and reconcile the missing
information or unclear requirement before dependent implementation proceeds.

## Exit and handoff

Record the verification plan, tests or procedures created, any baseline evidence, and remaining execution needs.
Assert is ready when the agreement has credible assessment methods and material verification gaps have a disposition.
Unresolved questions that prevent defining success require a decision rather than a claim of readiness.

Hand Code the approved agreement, assertions, and relevant findings. A changed verification strategy may require
renewed evaluation of existing work even when the implementation itself does not change.
