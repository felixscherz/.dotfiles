---
name: agents-folder-conventions
description: Conventions for the personal `.agents/` workspace (issues, features, specs, tickets) in repos that have not adopted it. Use before committing anything under .agents/, before adding it to a PR or .gitignore, and before referencing .agents/ paths in PR descriptions, commit messages, or issue comments.
---

# .agents folder conventions

The `.agents/` directory - `.agents/issues/`, `.agents/features/`, and config files like `issue-tracker.md` - is the user's personal delivery-pipeline workspace, used by `triage`, `to-spec`, `to-tickets`, `batch-implement`, `catch-up`, and `ship-feature`. The user works in many repos that have not adopted this structure and does not want it imposed on them. The pipeline works fine either way; the only question is whether its files enter the repo's history.

## Decide whether the repo has adopted `.agents/`

Check once per session, before the first commit or PR that could touch the workspace:

- `git ls-files .agents` - tracked files under `.agents/` mean the repo has adopted the structure.
- `git check-ignore -q .agents` - an ignore rule means the repo has decided the folder stays out.

Three cases:

1. **Adopted** (tracked files exist): commit `.agents/` changes like any other file, per the repo's normal conventions.
2. **Not adopted** (nothing tracked): treat `.agents/` as local-only working state. Apply the default posture below.
3. **User instructs otherwise**: an explicit instruction to commit or ship the workspace overrides the default, for that repo.

When in doubt - for example, the repo tracks a `.agents/` that looks nothing like this structure - ask rather than assume adoption.

## Default posture in repos that have not adopted it

- Do not `git add` anything under `.agents/`; the files stay untracked and work as well from there.
- Sweep before every commit and PR: nothing under `.agents/` staged, none of it in the diff being shipped.
- Do not edit the repo's `.gitignore` to hide the folder - that is also an imposition. If local ignoring helps (cleaner `git status`), use `.git/info/exclude`, which stays out of the repo's history.
- Generated scaffolding (`implement.sh`, `progress.json`, `summary-NN.md`) is local-only for the same reason.

## Outward references may dangle

When `.agents/` is not committed, its paths mean nothing to anyone but the user. A PR description linking `.agents/features/<feature>/spec.md`, a commit message citing a ticket file, or an issue comment pointing into the workspace references a file reviewers cannot open.

So in repos that have not adopted the structure:

- **PR descriptions**: inline the substance instead of linking. Summarize the spec, paste the relevant requirements or acceptance criteria, describe the verification that was run.
- **Commit messages**: name tickets by title ("add retry to the sync client"), not by path (`ticket-03.md`).
- **Pipeline skills that say to link workspace files** (for example `ship-feature`'s PR description linking `spec.md`): apply this rule on top - link only when the file is committed, otherwise inline what the reader needs.

References inside the workspace itself (a ticket linking the spec, the feature README linking tickets) are always fine - their audience is the user and the pipeline, not the repo.

## Related

- `setup-agents` - scaffolds `.agents/` config; running it in a repo is a deliberate adoption decision, not a default.
- `ship-feature` - decides with the user whether workspace changes ship in the PR; this skill supplies the default answer.
- `triage`, `to-spec`, `to-tickets`, `batch-implement`, `catch-up` - all write into `.agents/`; their output stays uncommitted under the default posture.
