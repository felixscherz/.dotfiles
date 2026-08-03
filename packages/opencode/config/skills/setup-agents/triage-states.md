# Triage States

Skills speak in terms of canonical triage states. This file maps those states to the actual `Status:` strings used in this repo's issue files.

Two **category** values (the `Category:` line): `bug`, `enhancement`.

Six **state** values (the `Status:` line):

| Canonical state   | Status string in this repo | Meaning                                         |
| ----------------- | -------------------------- | ----------------------------------------------- |
| `needs-triage`    | `needs-triage`             | Captured, not yet evaluated                     |
| `needs-info`      | `needs-info`               | Waiting on the user for more info or a decision |
| `ready-for-agent` | `ready-for-agent`          | Fully specified, an agent can pick it up        |
| `ready-for-human` | `ready-for-human`          | Requires human implementation                   |
| `wontfix`         | `wontfix`                  | Will not be actioned (reason recorded in file)  |
| `done`            | `done`                     | Implemented and verified                        |

When a skill mentions a state (e.g. "move this issue to ready-for-agent"), use the corresponding string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.
