---
name: code-review
description: Apply when reviewing a pull request or a set of code changes, your own or someone else's - "review this PR", "code review", "look over these changes", "review my branch", or a PR number or URL to review.
---

# Code review

A review has two jobs:

1. Confirm that the reviewer understood the change the way the author meant it.
2. Find what stands between the change and merging it.

The first job is the one that usually gets skipped. Without a stated intent, a
reviewer can only check that code looks reasonable, not that it does what it
was supposed to do. So intent comes first, and the review output restates the
change in the reviewer's own words so the author can catch a mismatch.

Writing the PR description is part of shipping, not reviewing. See
`ship-changes/ship-changes.md`.

## Workflow

### 1. Gather the material

Collect the PR description, the full diff, the commit messages, linked issues
or tickets, and CI status. For GitHub PRs, `gh pr view <n>`, `gh pr diff <n>`,
`gh pr checks <n>` and `gh pr view <n> --comments` cover most of it. For a
local branch, diff against the merge base with the target branch.

Read surrounding code, not just the diff. A change is only understandable in
the context of what it touches.

### 2. Establish the intent

Before judging any code, write down in one or two sentences what the change is
trying to achieve and why. The PR description should say so (see
`ship-changes/ship-changes.md` for what a good one covers), but do not reject a
description for following the project's own format instead of that template.

If the motivation is missing or too vague to review against, stop and discuss
it with the user before reviewing. Do not silently guess. The PR may be the
user's own work or a third party's, so ask which, then agree on how to get the
intent:

- **User's own PR:** ask them for the motivation and offer to update the
  description with it.
- **Someone else's PR:** ask what the user knows about it. Offer to infer the
  intent from commits, linked issues, branch name, and code, clearly marked as
  inferred and confirmed by the user before relying on it. Offer to draft
  questions for the author as a PR comment.

A review against an unconfirmed intent must say so at the top of the output.

### 3. Calibrate scrutiny

Not every line deserves the same depth. Assess each area of the change along
two axes and spend attention accordingly:

- **Blast radius** - how much breaks, and how badly, if this is wrong. Auth,
  payments, data migrations, shared libraries, public APIs and anything
  touching persistent data sit at the high end.
- **Longevity** - how long this code will live and how much will be built on
  it. A one-off script or a throwaway experiment sits at the low end. Core
  domain concepts sit at the high end.

Weight modelling over mechanics. A core domain concept deserves close
attention to whether its invariants hold, whether it is expressed in the right
terms, and whether the boundaries sit in the right place. A mistake there
spreads into everything built on top and is expensive to undo. An adapter at
the edge (a database adapter, an HTTP client, a serializer) still has to be
correct, but a clumsy one is cheap to replace later.

State the calibration in the output, so the author knows which parts got deep
scrutiny and which got a lighter pass.

### 4. Check the implementation against the intent

With the intent fixed, ask whether the change actually achieves it:

- Trace the main code paths end to end. Does the behavior match the stated
  goal, including edge cases, error paths, concurrency, and empty or invalid
  input?
- Do the invariants of the affected domain concepts still hold after the
  change, on every path that mutates them?
- Do the tests exercise the intended behavior, or only the happy path or the
  implementation details?
- Is there anything in the diff the intent does not explain? Unexplained
  changes are either scope creep or a sign the stated intent is incomplete.
  Ask about them.
- Is anything the intent implies missing from the diff?

### 5. Naming

Names are how a codebase carries its model. Check every new or changed name
(types, functions, modules, fields, variables with a wide scope, config keys,
endpoints):

- Does it say what the thing is or does, without reading the implementation?
- Does it match the domain language used elsewhere in the codebase and by the
  people who own the domain?
- Is the same concept named the same way everywhere, and are different
  concepts named differently?
- Does it still fit after the change, or did the thing's meaning drift while
  the name stayed?

An unclear name, a better name that is clearly available, or a name that does
not align with the model is a **blocker**. Suggest the alternative.

### 6. Changes to existing tests

New tests describe new behavior. A changed existing test means the behavior
it pinned down has changed, or the test was bent to make the build pass.
Either way it deserves extra attention, because it is where a regression
shows up in the diff while the rest of the change looks fine.

For every existing test whose assertions, inputs, expected values, fixtures,
snapshots, or golden files changed:

- Name the behavior the test pinned before and what it pins now.
- Check that the behavior change is part of the stated intent. A behavior
  change the description does not mention is an open question at least.
- Check who else relies on the old behavior: callers, users, other services,
  stored data (see `dont-break-production.md`). An intended change can still
  break someone.
- Confirm with the user that the behavior change is acceptable when it is
  observable outside the codebase.

A test that only moved, was renamed, or was rewritten against a new internal
API while asserting the same behavior is a refactor. Say so and move on.

### 7. Removed or weakened verification

Treat any removal or weakening of verification as suspicious until justified.
Enumerate every instance explicitly, for example:

- deleted test files or test cases
- tests marked skip, xfail, only, or commented out
- loosened assertions, widened tolerances, updated snapshots or golden files
- mocks introduced where a real dependency was used before
- CI jobs or steps removed, made optional, or set to continue on error
- lowered coverage thresholds, disabled lint rules, added ignore comments
- changed timeouts or retry counts that could hide flakiness

For each one, find the justification in the description, the commits, or the
code itself (for example, the tested behavior was intentionally removed). The
question is whether the change to verification follows from the intended
change to behavior, or whether it was made to get a red build green. If no
justification exists, it is a **blocker**.

### 8. Classify findings

- **Blocker** - must be resolved before merging. This includes: the change does
  not achieve its intent, broken invariants, correctness or security bugs,
  data loss risk, naming problems as defined above, an unexplained behavior
  change in an existing test, unjustified test or CI removal, and missing or
  unconfirmable intent.
- **Non-blocker** - worth raising, fine to merge without. Suggestions, style,
  small refactors, follow-up ideas, questions that do not affect correctness.

Weigh severity by the calibration from step 3. The same flaw can be a blocker
in core domain code and a non-blocker in a throwaway script, except for the
categories named above as blockers.

Every finding needs a location (`path:line`), what is wrong, why it matters,
and a concrete suggestion. Drop findings you cannot back up with the code.

## Output

Present the review to the user in this shape:

```markdown
## Summary of changes

<The intent and the change, in your own words, not copied from the PR
description. What problem this solves, what the change does to solve it, and
how the pieces fit. Written so the author can read it and say "yes, that is
what I meant" or spot where the reviewer got it wrong. Mark it if the intent
was inferred rather than stated.>

## Review focus

<Which areas got deep scrutiny and which got a lighter pass, and why, based
on blast radius and longevity.>

## Behavior changes

<Each existing test whose expectations changed: the old behavior, the new
behavior, and whether the intent covers it.>

## Blockers

1. **<short title>** - `path:line`
   <What is wrong, why it matters, suggested fix.>

## Non-blockers

1. **<short title>** - `path:line`
   <What and why, suggested change.>

## Open questions

<Questions for the author where the answer could change the verdict.>
```

Omit a section only if it is empty, and say "None" for Blockers rather than
dropping it. Apply the `unslop` skill to the prose.

Do not post the review or any comment to GitHub (or elsewhere) without the
user's go-ahead. Offer to post it once the user has read it.
