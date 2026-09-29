---
name: domain-driven-design
description: Apply when naming or modelling domain concepts in code, adding a feature or process that spans several services, or when domain logic is scattered across layers.
---

# Domain-driven design

DDD gives the user and the agent a shared language. When code uses the
domain's names, the user can name a concept and the agent can find it, and a
complex process can be explained in domain terms instead of implementation
details. This holds for every name in code: types, functions, and methods,
not only entities.

- Name everything in the domain's own words, down to functions and methods.
  When code and domain use different words for one thing, align them.
- Give each domain concept its own type. A value object for things defined by
  their value (an email, a money amount), an entity for things with identity
  and a lifecycle.
- Keep the domain model free of framework, HTTP, and database concerns.
  Adapters translate at the edges.
- Group things that must change together into an aggregate, and change them
  only through one entry point that enforces the invariants.
- Orchestrate multi-step intents in use cases named after the intent
  (`CancelOrder`). A use case loads inputs, calls focused domain behavior,
  persists results, and owns the transaction boundary. Entry points delegate
  to one application operation rather than coordinating several services.
  Do not add a pass-through use case when one focused operation already
  handles the intent. Use cases do not call other use cases, and domain
  services do not orchestrate other services.
- Draw bounded contexts where the same word means different things. A
  "customer" in billing and in support may be two models, not one.
