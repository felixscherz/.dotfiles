---
name: agents-folder
description: Use whenever you need somewhere to put files while working on a task - a scratch workspace, a document for the user to read (summary, implementation plan, investigation notes, review), a handoff note for another agent, or a place shared with other agents on the same task. Also use when the user says "write it to a file", "put the plan somewhere", "hand this off", or gives you a `.agents/tasks/...` path, and before committing or referencing anything under `.agents/`.
---

# .agents folder

`.agents/tasks/<task-id>/` is a per-task workspace for agents. Use it for anything you produce while working that is
not product code: documents for the user (summaries, plans, findings), scratch files, handoff notes for another
agent, and shared state when several agents work on the same task.

One folder per task keeps agents on different tasks out of each other's way.

## Find or create the task folder

1. If the user, an orchestrator, or a handoff note gave you a task folder path, use that folder. Read its
   `README.md` first.
2. Otherwise create a new one. Do not reuse a folder that belongs to unrelated work.

Place `.agents/` at the root of the primary checkout of the current repository, so agents in different worktrees of
the same repository share one location. Resolve it with:

```sh
dirname "$(git rev-parse --path-format=absolute --git-common-dir)"
```

Outside a git repository, use the current working directory.

Name a new folder `<YYYYMMDD-HHMMSS>-<short-slug>`, using local time and a short kebab-case description of the task,
for example `20260924-143012-auth-token-refresh`. Check that it does not already exist before creating it.

## README.md

Every task folder has a `README.md` describing what the task is about, so any agent or human opening the folder
understands it. For example:

```markdown
# Refresh auth tokens before expiry

Users get logged out mid-session because access tokens expire without being refreshed. Add background refresh
in the API client and cover it with tests.

Status: in progress
```

Put everything else in the folder as files with descriptive names. Only edit files you created, unless you are
updating the README to reflect the current state.

## Documents for the user

When the user asks for a summary, plan, or write-up, write it to the task folder and give them the absolute path.
Write for a reader without your context and keep the chat reply to a short summary.

## Handing off to another agent

Write a handoff document so a fresh agent with no context can continue: the goal, current state, decisions made,
where the work lives (repository, branch, files), open questions, and skills to load. Reference existing files, specs,
commits, or PRs instead of duplicating them. Leave out secrets. Give the user the path so they can pass it on.

## Keep task folders out of git history

`.agents/tasks/` is local working state. When it is not already tracked in the repository:

- Do not stage or commit anything below it, and do not edit `.gitignore` to hide it.
- Add `/.agents/tasks/` to the local exclude file at `$(git rev-parse --git-path info/exclude)` if it is not
  already present.

If files below `.agents/tasks/` are already tracked, leave them alone and ask the user how to handle them.

Other `.agents/` content may be an established structure in the repository: follow what is already tracked or
ignored, and keep new content local unless the user asks for it to be committed.

Do not cite `.agents/` paths in commit messages, pull request descriptions, or anything else read by people who
cannot open the local files. Inline the relevant content instead.

Keep task folders after the task is done. Delete one only when the user asks.
