---
name: feature-map
description: Apply at the start of a task in a codebase, when looking for where a feature lives, and after adding, moving, renaming, or removing a feature.
---

# Feature map

A feature map lists every observable feature of a system, named in the
domain's words, and points to where it lives in the code. It lets an agent go
from "the user means X" to the right place without searching the whole
codebase. It lives at `.felixws/FEATURE_MAP.md` in the repository root. That
directory is personal and globally git-ignored, so read it by path; search
tools that respect `.gitignore` will skip it.

- Read the map before exploring the code. When it is missing, offer to build
  it with the user instead of building it alone.
- Build it together. Propose the features and their names, and let the user
  correct them. The user knows the domain language, and the map is only
  useful if both sides use the same names (see `domain-driven-design.md`).
- List features as someone outside the code observes them: an endpoint, a
  command, a screen, a scheduled job, an emitted event. Group them by domain
  area.
- Point to modules, directories, and key types, not lines or functions that
  churn. The map guides a search; it does not replace one.
- Keep it current. When a task adds, moves, renames, or removes a feature,
  update the map in the same task. When the map points to the wrong place, fix
  it.

```markdown
## Payments

- **Refund a payment** - `POST /payments/{id}/refunds`. Domain in
  `payments/domain/refund.py` (`Refund`), wiring in `payments/api/`.
- **Nightly settlement** - scheduled job, `payments/jobs/settlement.py`.
```
