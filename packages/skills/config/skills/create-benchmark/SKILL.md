---
name: create-benchmark
description: Capture a piece of real engineering work (a finished task, merged PR, or agent session) as a new benchmark-<slug> skill for the benchmarking-the-harness framework. Use when the user wants to create, write, or add a benchmark, or turn something they just worked on into one.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Create a benchmark

A benchmark is a real task from day-to-day work, frozen so candidates can
redo it: the repository as it was before the work, the request as it was
made, and a rubric for what a good result looks like. The benchmarks together
form the collection: the work the user wants their environment to handle
well.

Read `../benchmarking-the-harness/SKILL.md` first: it defines the vocabulary,
the blinding rules, and the contract this skill produces.

A benchmark does not need a special aspect or trap. Its value is that it is
real work. A benchmark where every variant does well still earns its place:
it catches a variant that makes ordinary work worse.

A good benchmark is:

- **Real** - taken from actual work, not invented.
- **Reproducible** - every trial starts from the identical state.
- **Gradeable** - the user knows what a good result looks like, because they
  did the work.
- **Neutral** - it rewards good outcomes, not compliance with one variant.

## 1. Pick the work

Good sources: a task the user just finished with an agent, a merged PR, a
closed issue. A good candidate:

- is completable in one session from the repository alone,
- has a result the user has judged (reviewed, merged, corrected),
- does not need live systems: production data, secrets, deployed services,
  or a human in the loop.

Gather, before writing any file:

- **Repository and base commit** - the state right before the work started.
- **Request** - the original prompt, or the issue or ticket it came from.
- **Reference outcome** - the change that was merged or accepted.
- **What mattered** - review comments, corrections the user made to an
  agent's work, things that went wrong. These become rubric criteria.

Name the skill after the work: `benchmark-<repo>-<short-task>`, e.g.
`benchmark-invoice-sync-retry-backoff`.

## 2. Decide where it lives

The dotfiles repo is public. Only benchmarks built from public code may go
into `packages/skills/config/skills/`. For anything from work or other
private code, ask the user for a private location. Never commit non-public
code, requests, or reviews into the dotfiles repo.

## 3. Build the fixture

The fixture is the repository at the base commit.

- **Pin it.** Write `fixture/setup.sh <target-dir>` that materializes the
  repository at the base commit SHA, either by cloning it or by restoring a
  `git bundle` stored in `fixture/`. Prefer a bundle for small repositories,
  it makes the setup offline and immune to force-pushes.
- **Remove the future.** A candidate must not find the answer in the
  repository. Drop every commit, branch, tag, and remote ref after the base
  commit, and remove the remotes. Check `git log --all` in the result.
- **Make it runnable.** If the work involved running tests or builds, the
  sandbox must be able to as well. Rely on the repository's lockfiles, and
  note in `SKILL.md` anything the setup needs (toolchain versions, services).
- **Blind it.** A real repository is naturally blind, but check that nothing
  in it refers to this capture. Name the sandbox directory after the
  repository.
- **Verify it.** Run the setup into a scratch directory. Confirm HEAD is the
  base commit, no later history is reachable, and the project builds and
  tests run as they did at the time.

## 4. Write the task

`task.md` holds the prompt exactly as the user would type it.

- Use the original prompt if there was one. If the work came from an issue
  or ticket, write the prompt the user would have typed, and include the
  issue text the way the user would have pasted it.
- Resolve references the candidate cannot follow (internal links, chat
  threads) by inlining the content that mattered, or dropping it if it did
  not.
- Never add hints the original request did not contain, about the solution
  or about what the rubric looks at.

## 5. Write the rubric and reference

`reference.patch` and `rubric.md` are only for the coordinator and the
judge. The judge grades each trial by reading how the task was done (the
trace) and the result (sandbox diff and final reply), and comparing them with
the reference. There are no automated checks.

- **Reference.** Store the accepted change as `reference.patch`. It is one
  acceptable solution, not the only one; the rubric says so, so the judge
  does not penalize a different approach that also solves the problem.
- **Criteria.** 3-6, each gradeable from the trace and the result. Cover:
  - whether the problem is actually solved, compared with the reference,
  - how the work was done: investigation before editing, verification
    before claiming done, questions asked or assumptions stated,
  - what mattered in the real review: scope, fit with the codebase's
    conventions, tests, the final report to the user,
  - anything that went wrong the first time.
- **Anchor every criterion** with what a full, partial, and failing result
  looks like, concrete to this work: file names, the behavior, the specific
  mistakes seen in review. A judge with vague criteria scores on style.
- **Variant-neutral.** Describe good outcomes, never "followed skill X". The
  benchmark must be able to show that a variant made things worse.
- **Trace expectations** (optional, separate section) are facts about the
  environment the coordinator checks after unblinding, e.g. "loaded the
  engineering skill before editing code". They name skills or instruction
  files, which the judge must not see, so they stay out of the criteria.

## 6. Write SKILL.md

Frontmatter: `name: benchmark-<slug>`, a one-line `description` of the work,
and model invocation disabled for every harness (see the `author-skill`
skill). A benchmark must never load in a normal session.

Body, in this order:

1. **Work** - one paragraph on what the task is and what a good result
   achieves.
2. **Source** - repository, base commit, PR or session, date.
3. **Required layers** - e.g. `global`, or "none".
4. **Setup** - how to materialize the fixture, e.g.
   `fixture/setup.sh <sandbox>`, plus anything the environment needs.
5. **Notes** - what went wrong or needed correcting in the original work, if
   anything.

Resulting layout:

```
benchmark-<slug>/
  SKILL.md
  task.md
  rubric.md
  fixture/
    setup.sh
    repo.bundle     # if restoring from a bundle
  reference.patch
```

## 7. Validate

1. **Leak check.** Materialize the fixture into a scratch directory. Confirm
   no history after the base commit is reachable and no part of the
   reference is present. Grep the fixture and `task.md` for the forbidden
   words from the blinding rules used in their meta sense.
2. **Dry run.** Run one trial per `benchmarking-the-harness` with the user's
   current environment. The benchmark is ready when the candidate could
   work on the task without getting stuck on the fixture, and a judge's
   scores follow the rubric anchors. If
   the judge's scores disagree with your own reading, fix the anchors.

Record the dry run in the agents folder (see the `agents-folder` skill).
Remind the user to commit the new benchmark wherever it lives.
