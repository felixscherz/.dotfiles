---
name: redesign-from-first-principles
description: Apply when requirements change or are added, when a drift between code and model is found, or when you are about to add a special-case condition for an edge case.
---

# Redesign from first principles

A special case for a new requirement is easy to add, but each one makes the
system harder to change. Most of the time, changing the model closer to the
foundation lets the requirement fit naturally. Redesign as if the requirement
had been there from the start.

- Before adding an `if` for an edge case, ask whether the model is missing a
  concept. A missing concept usually shows up as a condition.
- When a requirement or a drift changes the model, change the model first, then
  migrate the code to it. Don't keep the old shape alive beside the new one,
  unless consumers still depend on it (see `dont-break-production.md`).
- Don't shy away from broad migrations when the model needs them, and clean up
  what the new model makes obsolete. When the migration reaches beyond the
  task, propose it with the old and new model side by side before starting.
  Deliver it in steps (see `deliver-in-small-steps.md`).
