---
name: find-the-root-cause
description: Apply when debugging a bug or investigating a failure. Trace the symptom through its inputs and state to the cause before choosing a fix.
---

# Find the root cause

Do not mistake the place where an error becomes visible for the place where it began. A guard that changes a crash into
an error response, or a new exception raised downstream of bad data, may make a failure easier to see without fixing it.
Such patches accumulate while the original defect keeps producing failures.

- Reproduce the symptom first. Record the inputs, state, and exact point of failure; write a failing behavioral test or a
  repeatable check when possible.
- Follow the data and control flow backward. Ask "why did this value or state reach this point?" until you find the
  violated invariant and the operation that first broke it. Read the actual error, logs, and persisted data. When the
  evidence runs out, instrument the flow rather than guessing.
- Fix the invariant where it is created or owned, then test both that the original symptom disappears and that the
  underlying bad state is no longer produced. Check other consumers and producers for the same pattern, not just the
  reported instance.
- Do not add a nil check, catch block, fallback, or new error solely to silence the symptom. A guard belongs at a real
  boundary when it enforces an invariant or handles an expected failure. If a workaround takes a paragraph-long comment
  to justify, revisit the model instead of explaining away the patch.
- If a mitigation is necessary before the cause can be fixed, label it as a mitigation, make the remaining failure
  observable, and keep investigating. Never claim to have fixed the root cause when its origin is still unknown.
