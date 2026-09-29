---
name: ship-changes
description: Apply when a change is done and needs to be integrated - committing, pushing, opening a pull request, or writing a PR description.
---

# Ship changes

A change is not done until it is integrated. Shipping means getting it past
every automated check and in front of a reviewer with enough context to judge
it quickly. The reviewer is usually the user, and their question is not only
"is this correct" but "is this what I want". The PR has to make that second
question easy to answer.

## Before opening the PR

- Work on a branch, never the default branch. Follow the repository's branch
  naming and commit message conventions (check `AGENTS.md`, `CONTRIBUTING.md`,
  commit history, commitizen or commitlint config).
- Run the same checks CI runs: tests, linters, formatters, type checks, and
  pre-commit hooks. Find them in the CI config (`.github/workflows/`,
  `.gitlab-ci.yml`, ...), `Makefile`, `justfile`, or package scripts rather
  than guessing.
- Everything must pass. Never skip, weaken, or delete a check to get green.
  If a check fails for a reason unrelated to the change, confirm that by
  running it on the default branch, and say so in the PR instead of hiding it.
- Read your own diff as a reviewer would. Remove debug output, commented-out
  code, and unrelated changes. If the diff does more than one thing, propose
  splitting it.
- Keep commits meaningful. Each commit message says why, not only what. Squash
  fixups that only make sense as part of another commit.

## Opening the PR

- Push and open the PR with the platform's CLI: `gh pr create` for GitHub,
  `glab mr create` for GitLab. Pass the description through a file
  (`--body-file`) so formatting survives.
- Target the branch the repository integrates into, usually the default
  branch.
- Open it as a draft when the change still needs input before it is
  reviewable, and say what input is needed.
- Never merge unless the user asks.

## After opening the PR

- Watch CI (`gh pr checks --watch`) and fix failures. A PR with red CI is not
  shipped.
- Report the PR link to the user along with the CI status.
- When feedback or new commits change the scope, update the description so it
  still matches the diff.

## The PR description

If the repository has its own template (`.github/pull_request_template.md` or
similar), use it, but make sure it covers the three sections below. Otherwise
use the template at the end of this file.

The description exists to let the reviewer verify two things: that the change
achieves its goal, and that it does so the way they would want. Write for a
reviewer who has not seen the work in progress.

- **Lead with motivation.** The problem, goal, or request that led to the
  change. This is the part that matters most and gets lost most often. If you
  do not know why the change was made, ask the user rather than invent a
  reason.
- **Surface decisions.** Name the choices the reviewer might disagree with:
  a design picked over an alternative, a trade-off accepted, a scope cut, a
  new dependency, a convention broken. State the alternative and why it lost.
  These are where "do I like this" gets decided, so do not bury them in the
  diff.
- **Flag uncertainty.** Say where you are unsure or want the reviewer's
  judgement.
- **Make verification concrete.** Commands to run, setup needed, expected
  result. Name the tests that cover the change. Call out any test or CI that
  was removed or weakened, with the reason.
- **Guide the reading order.** Point to where the core of the change lives,
  most important first, and mark what is mechanical (renames, moves,
  generated code) so the reviewer can skim it.
- Keep it short and plain. No filler, no restating the diff line by line.

### Template

```markdown
## What changed and why

<!--
A few sentences. Lead with the motivation: the problem, goal, or request that
led to this change. Then say what was changed to address it. A reviewer who
only reads this section should know what the PR is trying to achieve and be
able to judge whether the diff achieves it. Call out decisions the reviewer
might disagree with and the alternatives considered. Link the issue or ticket
if one exists, but do not rely on the link alone.
-->

## How to test

<!--
The test strategy. Which automated tests cover the change (new, changed, or
existing), and how to verify it manually if that matters: commands to run,
setup needed, expected result. If tests or CI were removed or weakened, say so
here and explain why.
-->

## Useful code paths

<!--
Where a reviewer should start. List the files or folders that carry the core
of the change, most important first, with a short note on each. Point out
anything mechanical (renames, generated code, moved files) that can be skimmed.
-->

- `path/to/file` - why it matters
```
