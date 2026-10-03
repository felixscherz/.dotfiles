# Don't break production

Code is judged by how it is used, not by how its interface looks. A change
that keeps every signature intact can still break production if it changes
what callers rely on. Breaking changes are sometimes right, but never by
accident and never lightly.

## Recognize a breaking change

- Visible changes: removing or renaming an endpoint, field, flag, or command;
  changing a type, format, status code, or default; tightening validation.
- Invisible changes, where the interface stays the same but the contract
  does not:
  - durability: a write that was persisted synchronously is now buffered, or
    data that was kept is now expired
  - retry and delivery semantics: at-least-once becomes at-most-once, retries
    are added or removed, backoff changes
  - ordering, idempotency, and concurrency guarantees
  - timeouts, rate limits, batch sizes, and latency or throughput that
    callers have come to depend on
  - error behavior: an error that used to surface is now swallowed, or the
    reverse
  - side effects: emitted events, notifications, logs, or metrics that
    something downstream consumes
- Judge by actual use, not documented intent. If a caller depends on a
  behavior, it is part of the contract, whether or not it was meant to be.
- Find the consumers: search the workspace for callers, check the workspace
  map, dashboards, and access logs. When you cannot tell who depends on the
  behavior, assume someone does.

## Ship it safely

A breaking change needs one of three things before it ships. Say which one in
the PR description.

- **Sign-off.** The user or the owners of the affected consumers agree that
  the break is acceptable. Name who agreed and what they agreed to.
- **Proof it does not reach production.** Evidence that no one relies on the
  old behavior: the endpoint has no traffic, the field is never read, the
  feature is not released or officially in use yet. Link or quote the
  evidence rather than asserting it.
- **Keep the old behavior available.** Ship the new code behind a feature
  flag, config switch, versioned API, or parallel path, with the old behavior
  as the default until consumers have moved. This lets the code merge now and
  the behavior change later, independently of the deploy.

When keeping the old behavior, plan its removal: name the condition for
flipping the default and deleting the old path, and track it. This is a
deliberate, time-boxed exception to not keeping an old shape alive beside the
new one.

## What does not count

- Keeping the PR open and waiting. The change rots, conflicts pile up, and
  nothing about the risk improves. Pick one of the three options instead.
- Assuming nobody uses it because you did not find a caller in this
  repository.
- Mentioning the break only in the diff. If the reviewer has to discover it,
  it was not disclosed.
