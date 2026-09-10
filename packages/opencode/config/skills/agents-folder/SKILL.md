---
name: agents-folder
description: Manage the personal `.agents/` workspace and create `.agents/tasks/<task-id>/` coordination records for orchestrated tasks. Use when an orchestrator starts or coordinates a task, before committing `.agents/` content, or before referencing `.agents/` paths outside the workspace.
---

# .agents folder

The `.agents/` directory is the user's personal agent workspace. It may contain other established structures, but
this skill is self-contained: it requires no repository scaffolding or configuration before creating and using an
orchestrated task workspace.

## Task workspaces

Create one workspace for each orchestrated task:

```text
.agents/tasks/<task-id>/
├── README.md
├── brief.md
├── assignments/
└── reports/
```

The task workspace is the durable communication boundary between the orchestrator, its subagents, and the human.
Record decisions, bounded assignments, concise reports, and current state. Do not store chat transcripts, chain of
thought, or raw command and tool output.

### Choose the task ID

Use an ID supplied by the human when available. Otherwise create a readable, collision-resistant ID in the form
`<YYYYMMDD-HHMMSS>-<short-slug>`, using local time and a short kebab-case description. Before creating it, verify
that `.agents/tasks/<task-id>/` does not already exist. Never reuse a task directory for unrelated work.

Create the workspace early enough to capture refinement decisions. Creating coordination files does not authorize
product-code changes.

### README.md

The orchestrator alone owns `README.md`. Keep it short and current rather than appending an event log. Include:

```markdown
# Task: <title>

Task ID: <task-id>
Status: refining
Implementation approval: pending

## Objective

<One concise statement of the desired outcome.>

## Method

Selected by: human | orchestrator | pending
Skill: <skill name | none | pending>
Description: <the method being used, or pending>

## Repositories and Worktrees

| Repository | Base | Branch | Worktree | State |
| ---------- | ---- | ------ | -------- | ----- |

## Assignments

| Assignment | Agent | State | Report |
| ---------- | ----- | ----- | ------ |

## Progress

<Current phase, active work, and material blockers.>

## Outcome

<Final commits, verification, review result, remaining risks, and handoff.>
```

Use task statuses that describe reality, such as `refining`, `ready`, `implementing`, `reviewing`, `blocked`,
`complete`, or `abandoned`. Record implementation approval as `pending`, `granted`, or `withdrawn`. Do not treat a
status transition as permission by itself; approval comes from the human conversation.

### brief.md

The orchestrator owns `brief.md`. Refine it with the human and keep it as the current task contract:

```markdown
# <Task title>

## Goal

## Desired Behavior

## Acceptance Criteria

## Constraints

## Non-goals

## Decisions

## Open Questions
```

Omit headings that do not apply. Preserve technical details that constrain implementation. Before implementation,
resolve every open question that would materially change the result or explicitly mark it as a delegated decision.

### Select and record the method

The human may name a skill, describe a method without a skill, or leave method selection to the orchestrator.

- Follow a human-selected method.
- Load a matching skill when one exists and record its name.
- A method does not require a skill. Record `Skill: none` and describe the method when no matching skill exists.
- When the human supplies no method, the orchestrator selects an appropriate one, states it to the human, and
  records `Selected by: orchestrator` before implementation.

Do not make this skill define the method. It owns task state and communication regardless of how the work is done.

### assignments/

The orchestrator writes one immutable assignment brief per delegation. Name files
`<NN>-<role>-<short-slug>.md`, using a unique sequence number within the task. Include:

- Assignment ID, role, and status
- Exact goal and boundaries
- The task brief path and any method instructions the agent must read
- Repository, branch, and worktree the agent may operate in
- Whether the assignment is read-only or may edit
- Expected deliverables and verification
- The unique report path the subagent owns
- Dependencies and relevant prior reports

Do not silently rewrite an assignment after dispatch. Add a new assignment that supersedes it, or append a clearly
labeled orchestrator amendment before the subagent continues.

### reports/

Each assignment has one corresponding report named like its assignment. The assigned subagent owns that report;
no two active subagents write the same file. A report contains only durable results:

- Result: complete, blocked, or failed
- Concise summary of work or findings
- Files or interfaces materially affected
- Verification performed and its outcome
- Commits produced, when applicable
- Review findings or unresolved risks
- Information the next agent needs

The orchestrator reads the report, updates the task README, and sends the human a consolidated update. Reports are
not a substitute for inspecting changes or verification evidence.

## Repository and worktree isolation

Record every repository involved in the README before assigning edits. For each repository, resolve and record the
canonical repository path, base branch and starting commit, task branch, worktree path, and current integration
state.

- A concurrently active task that modifies a repository gets its own worktree and branch unless it already started
  inside a worktree dedicated to that task.
- Do not let concurrent editing agents share a worktree.
- Read-only agents may inspect an implementation worktree concurrently.
- Prefer one implementation writer in a worktree. When a method calls for parallel writers, create separate
  worktrees and record which agent owns integration.
- A task spanning repositories uses one worktree per modified repository. Keep one canonical task workspace in the
  orchestrator's control repository and give subagents its exact path.
- Follow repository-specific branch naming and worktree rules when present. Otherwise use a task-derived branch
  name and a sibling worktree location that cannot collide with another active task.

Resolve existing branches and worktrees before creating new ones. Never delete a worktree or branch merely because
a task completed; cleanup is a separate action that requires the human's instruction or an explicitly selected
method that includes it.

## Keep task workspaces local by default

`.agents/tasks/` is operational state and stays local even when a repository tracks other `.agents/` content. The
human may explicitly override this for a repository.

When `.agents/tasks/` is not already tracked:

- Do not stage or commit anything below it.
- Do not edit the repository's `.gitignore` merely to hide it.
- Add the exact root-relative pattern `/.agents/tasks/` to the repository's local exclude file, obtained with
  `git rev-parse --git-path info/exclude`, if the pattern is not already present.
- Before each commit and pull request, confirm that no task-workspace file is staged or included in the outgoing
  diff.

If tracked files already exist below `.agents/tasks/`, do not remove or ignore them. Ask the human whether that
repository intentionally adopted task histories before changing their treatment.

## Other .agents content

For `.agents/` paths outside `tasks/`, determine their repository posture before committing them:

1. `git ls-files .agents` shows tracked files: treat the established tracked structure normally.
2. An ignore rule covers the relevant path: keep it local.
3. Nothing is tracked or ignored: keep new personal workspace content local unless the human explicitly asks the
   repository to adopt it.

Do not add a broad `.agents/` rule to `.gitignore` or the local exclude file because doing so could hide unrelated
tracked or intentional workspace structures.

## Outward references

Do not cite local-only `.agents/` paths in commit messages, pull request descriptions, issue comments, or other
communication whose readers cannot open them. Inline the relevant task definition, decisions, and verification
instead. References between files inside the task workspace are fine.

If the human explicitly chooses to commit a task workspace, its paths may be referenced only after they are part of
the published history.

## Finalize a task

Before marking a task complete, the orchestrator records:

- The final repository branches and commits
- Acceptance-criteria verification
- Independent review result and resolved findings
- Remaining risks or follow-up work
- Anything the human needs to resume, integrate, publish, or clean up

Keep the workspace after completion unless the human explicitly asks to remove it. It is the compact handoff for a
future session if the conversational context is lost.
