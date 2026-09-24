---
name: worktree-isolation
description: Create and use a separate Git worktree for isolated implementation. Use when the user says "do the work in an extra worktree", "use worktrees for isolation", asks to keep changes out of the current checkout, or assigns work that must happen in its own worktree.
---

# Worktree isolation

Create the worktree before making task changes, then perform the whole task inside it. The user's request to use a
worktree authorizes creating the worktree and its branch. It does not by itself authorize commits, integration,
publication, or cleanup.

## Convention

Honor repository-specific instructions first. Otherwise:

- Put linked worktrees below `.worktrees/` in the primary checkout.
- Name each directory after the branch with `/` and other unsuitable path characters replaced by `-`. For example,
  branch `fix/login-timeout` uses `.worktrees/fix-login-timeout`.
- Use a concise task-derived branch name that follows the repository's existing branch naming style. Use a branch
  supplied by the user unchanged.
- Treat the worktree as durable until the user asks for cleanup. Do not remove the worktree or delete its branch at
  task completion.

The global excludes file in this dotfiles setup ignores `/.worktrees/`. Do not add `.worktrees/` to a repository's
tracked `.gitignore`. If the directory is not ignored in another environment, add `/.worktrees/` to that repository's
Git-local exclude file obtained with `git rev-parse --git-path info/exclude` before creating the worktree.

Keeping worktrees inside the primary checkout makes them easy to locate while the ignore rule prevents the primary
checkout from reporting their files. Exclude `.worktrees/` from tools that do not honor Git ignores, especially
recursive search, file watching, backup, and formatting commands. Do not run broad cleanup commands across the
directory.

## Create or reuse the worktree

1. Confirm this is a Git repository and inspect repository instructions.
2. Run `git worktree list --porcelain`, identify the primary checkout, and resolve the requested branch and intended
   start point. If no start point was supplied, use the current `HEAD` at the time of the request.
3. Inspect `git status --short` before creating anything. A new worktree starts from a commit and does not include
   uncommitted changes. If the task depends on uncommitted changes in the current checkout, stop and ask how the user
   wants them handled. Do not stash, copy, or commit them without instruction.
4. Check for an existing branch, registered worktree, or filesystem path with the intended names. Reuse an existing
   worktree only when it clearly belongs to this task. Otherwise choose a non-conflicting task-derived name or ask
   when changing the requested branch would matter.
5. Confirm the planned nested path is ignored with `git check-ignore`. Create the branch and worktree from the
   resolved start point with `git worktree add -b <branch> <path> <start-point>`. If the branch already exists and is
   not checked out elsewhere, use `git worktree add <path> <branch>` instead.
6. Verify the new checkout's branch, `HEAD`, and clean status. Report its absolute path and branch to the user.

Do not use `--force` to override a registered or locked worktree. Do not prune, unlock, move, or remove an existing
worktree merely to make the desired path available.

## Work inside it

After creation, use the worktree path as the working directory for every task command, edit, test, and Git check.
When a tool cannot set a working directory, address files through the worktree's absolute path. Do not make task
changes in the primary checkout.

Before handing off:

- Run the task's relevant verification inside the isolated worktree.
- Show `git status --short` and the diff from inside that worktree.
- Confirm the primary checkout has no task changes caused by the work.
- Tell the user the worktree path, branch, verification result, and whether changes remain uncommitted.
