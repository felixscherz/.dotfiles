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
- Use the domain types the codebase already has in every signature you touch.
  When a type exists for a value, never pass the bare primitive instead.
- Make accepted keyword names visible to callers. Prefer explicit parameters
  over `**kwargs` when the set of keys is small. When `**kwargs` is warranted,
  type its keys and values with `Unpack[TypedDict]` rather than a value type
  alone, so callers can see which keys are required or optional.
- Avoid `Any` and `object` whenever anything is known about the value. Both
  tell the reader and the type checker almost nothing. Reach for a union, a
  protocol, or a type variable instead. The same goes for containers: avoid
  `dict[str, Any]` when the shape is known. Known keys call for a `TypedDict`
  or a model, uniform values for a precise value type such as
  `dict[UserId, Balance]`, and arbitrary JSON for a recursive `JsonValue`
  alias. Keep `Any` and `object` for values that are genuinely opaque to the
  code at hand.
- Never loosen an existing type to fit an edge case, such as making a required
  field optional or widening it to a primitive. That changes the model and
  needs the user's go-ahead (see `redesign-from-first-principles.md`).
- Parse external data into typed values at the boundary. Inside, trust the
  types instead of re-checking.
- Scale the effort to the code's expected lifespan. Core domain logic and
  models are always fully typed. A one-off script needs no types.
