---
name: batch-implement
description: Generate a resumable shell script that implements ticket-NN.md files sequentially through OpenCode, Claude Code, or Pi. Defaults to OpenCode. Use after to-tickets when the user says "batch implement", "implement tickets", "run tickets through an agent", "generate implement script", or "create orchestration script".
---

# Batch implement

Generate a shell script that feeds ticket files sequentially to a fresh coding-agent invocation. Keep orchestration, prompts, progress tracking, and completion checks independent of the selected harness.

Default to OpenCode. If the user asks for Claude Code or Pi, generate the script for that harness instead. If they name another harness, inspect its installed CLI and adapt the same protocol rather than assuming OpenCode flags.

## Prerequisites

- Tickets already exist as `.agents/features/<feature>/ticket-01.md`, `ticket-02.md`, and so on, normally produced by `to-tickets`.
- The tickets carry `Status: ready-for-agent` and use `Blocked-by:` for dependencies.
- `jq` and the selected harness executable are available.

## Process

### 1. Locate and validate the tickets

Find the feature workspace at `.agents/features/<feature>/` (or `.agents/<context>/features/<feature>/` in a multi-context repo). Read `spec.md` and every `ticket-NN.md` in full.

Sort tickets by numeric suffix. Validate that every `Blocked-by:` reference exists and precedes the blocked ticket. Stop and report invalid or cyclic dependencies rather than generating an unsafe order.

### 2. Select and verify the harness

Use the harness requested by the user, defaulting to OpenCode. Before writing the script, run the installed executable's `--help` and verify its current non-interactive and permission flags. Do not copy stale flags from this skill when the installed CLI disagrees.

Known invocation shapes at the time this skill was written:

| Harness | Executable | Non-interactive invocation |
| ------- | ---------- | -------------------------- |
| OpenCode | `opencode` | `opencode run --auto "$prompt"` |
| Claude Code | `claude` | `claude --print --permission-mode bypassPermissions "$prompt"` |
| Pi | `pi` | `pi --print "$prompt"` |

Use unattended permission modes deliberately. Tell the user which permission behavior the generated script uses. Do not silently fall back to a different harness when the requested executable is unavailable.

### 3. Draft one prompt per ticket

Each prompt must:

- Reference the ticket path so the harness reads the complete brief. Use the harness's supported file-reference syntax; `@<path>` works for the three known harnesses.
- Instruct the agent to implement and verify the ticket.
- Instruct it to update the ticket's `Status:` to `done` only after verification succeeds.
- Instruct it to append a dated closing note describing what changed and how it was verified.
- Instruct it to write a concise implementation summary to `.agents/features/<feature>/summary-<NN>.md`.
- Instruct it to create a commit after completing the ticket.
- Remind it that `spec.md` is shared context when cross-ticket design constraints matter.

Default prompt:

```text
Implement the ticket at @<ticket-path>. Read @<spec-path> for shared design constraints. Follow the agent brief and verify every acceptance criterion. When verification succeeds, set the ticket Status to "done", append a dated closing note, write a concise implementation summary to <summary-path>, and create a commit. If blocked or verification fails, leave the ticket unfinished and report the blocker.
```

The summary path is literal rather than an `@` reference because the agent creates it. The user may override the global template or individual prompts.

### 4. Confirm the execution plan

Show the selected harness, unattended permission behavior, ordered tickets, blocking edges, and proposed prompts. Ask the user to confirm the order and adjust or skip tickets before writing the files.

### 5. Generate the script and progress file

Write these files at the repo root:

- `implement-<feature>.sh`
- `progress-<feature>.json`

The script must:

- Check for `jq`, the selected harness executable, the progress file, and every ticket before starting.
- Prevent idle system sleep on macOS for the life of the script by starting `caffeinate -i -w $$` when available.
- Read progress state on startup.
- Skip tickets already marked `done`.
- Resume from the first `not-started` or `error` ticket.
- Mark a ticket `in-progress` immediately before invoking the harness.
- Start a fresh harness invocation for every ticket.
- Mark a ticket `done` only when the command exits successfully and the ticket file contains `Status: done`.
- Mark a ticket `error` and stop when invocation or completion verification fails.
- Be executable.

Progress file:

```json
{
  "feature": "<feature>",
  "harness": "opencode",
  "tickets": [
    {"file": "./.agents/features/<feature>/ticket-01.md", "status": "not-started"},
    {"file": "./.agents/features/<feature>/ticket-02.md", "status": "not-started"}
  ]
}
```

Valid progress statuses are `not-started`, `in-progress`, `done`, and `error`.

Use this structure, replacing `run_harness` with the verified invocation for the selected harness and filling the ticket and prompt arrays:

```bash
#!/usr/bin/env bash
set -uo pipefail

# Generated by batch-implement
# Feature: <feature>
# Harness: <harness>

PROGRESS_FILE="./progress-<feature>.json"
HARNESS_BIN="opencode"

if [[ "$(uname -s)" == "Darwin" ]] && command -v caffeinate >/dev/null 2>&1; then
	caffeinate -i -w $$ &
fi

files=(
	"./.agents/features/<feature>/ticket-01.md"
	"./.agents/features/<feature>/ticket-02.md"
)

prompts=(
	'<prompt for ticket 01>'
	'<prompt for ticket 02>'
)

run_harness() {
	local prompt="$1"
	opencode run --auto "$prompt"
}

get_status() {
	local file="$1"
	jq -r --arg file "$file" '.tickets[] | select(.file == $file) | .status' "$PROGRESS_FILE"
}

set_status() {
	local file="$1"
	local status="$2"
	local tmp
	tmp=$(mktemp)
	jq --arg file "$file" --arg status "$status" \
		'(.tickets[] | select(.file == $file)).status = $status' \
		"$PROGRESS_FILE" > "$tmp" && mv "$tmp" "$PROGRESS_FILE"
}

ticket_is_done() {
	local file="$1"
	grep -Eqi '^Status:[[:space:]]*done[[:space:]]*$' "$file"
}

command -v jq >/dev/null 2>&1 || { printf 'Missing dependency: jq\n' >&2; exit 1; }
command -v "$HARNESS_BIN" >/dev/null 2>&1 || { printf 'Missing harness: %s\n' "$HARNESS_BIN" >&2; exit 1; }
[[ -f "$PROGRESS_FILE" ]] || { printf 'Missing progress file: %s\n' "$PROGRESS_FILE" >&2; exit 1; }

for file in "${files[@]}"; do
	[[ -f "$file" ]] || { printf 'Missing ticket: %s\n' "$file" >&2; exit 1; }
done

for i in "${!files[@]}"; do
	file="${files[$i]}"
	prompt="${prompts[$i]}"
	status=$(get_status "$file")

	if [[ "$status" == "done" ]]; then
		printf '==> Skipping (done): %s\n' "$file"
		continue
	fi

	printf '==> Implementing: %s\n' "$file"
	set_status "$file" "in-progress"

	if time run_harness "$prompt" && ticket_is_done "$file"; then
		set_status "$file" "done"
		printf '==> Completed: %s\n' "$file"
	else
		set_status "$file" "error"
		printf '==> Failed: %s\nFix the issue and rerun this script to resume.\n' "$file" >&2
		exit 1
	fi
done

printf '==> All tickets implemented.\n'
```

Harness-specific `run_harness` examples after verifying local help:

```bash
# OpenCode
opencode run --auto "$prompt"

# Claude Code
claude --print --permission-mode bypassPermissions "$prompt"

# Pi
pi --print "$prompt"
```

Use safe shell quoting when embedding prompts. Generate the JSON with valid escaping. Make the script executable with `chmod +x`.

### 6. Report

Tell the user:

- The generated script and progress paths.
- The selected harness and permission mode.
- How to run the script.
- That rerunning skips completed tickets and resumes at the first error or unstarted ticket.
- That each ticket gets a fresh agent context and tickets run sequentially.
- That macOS idle sleep is inhibited while the script runs when `caffeinate` is available. This does not promise to keep a Mac awake with its lid closed.
- Where ticket summaries are written.

## Customization

The user may request prompt overrides, skipped tickets, a dry-run flag, a regenerated progress file, a different model, or a different harness. Treat model and permission flags as harness-specific options and verify them against the installed CLI.

## Related

- `to-tickets` - produces the `ticket-NN.md` files this skill consumes.
- `to-spec` - produces the shared `spec.md` that constrains those tickets.
- `triage` - manages ticket lifecycle; tickets move to `done` only after implementation and verification.
