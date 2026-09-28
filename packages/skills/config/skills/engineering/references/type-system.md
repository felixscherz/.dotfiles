---
name: type-system
description: Apply when designing types, signatures, or data shapes, or when reaching for a plain string, dict, or bool to carry something with meaning.
---

# Type system

Types do two jobs. They verify, turning a class of errors into lint or compile
failures. Just as important, they convey intent. A well-typed API surface
explains behavior without reading the implementation. Use the richer types the
language offers instead of cramming everything into primitives.

- Make illegal states unrepresentable. Prefer a union of explicit variants over
  a record of optional fields and flags that only some combinations make valid.
- Replace primitives that carry meaning. An enum or literal over a magic
  string, a dedicated type over a bare `str` or `int` for an ID or a unit, a
  typed model over a `dict`.
- Parse external data into typed values at the boundary. Inside, trust the
  types instead of re-checking.
- Scale the effort to the code's expected lifespan. Core domain logic and
  models are always fully typed. A one-off script needs no types.
