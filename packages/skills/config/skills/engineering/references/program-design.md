---
name: program-design
description: Apply when designing a new module, API, or model, deciding where code lives in a codebase, or when code turns out hard to test.
---

# Program design

Structure a codebase so its parts can be used, and therefore tested, on their
own. Testability is a first-class design goal, not an afterthought. A test is
the first user of an API, and code that is awkward to test is awkward to use.

- Keep a pure core. Domain logic takes values and returns values. Side effects
  (database, HTTP, filesystem, clock) live at the edges.
- Build seams. Dependencies with side effects come in through parameters or
  interfaces, so tests pass in-memory fakes instead of patching.
- Keep the public surface small and deliberate. Tests target it, so everything
  behind it can change freely.
- When designing an API or model, write the calling code, a test or an
  example, before the implementation.
- Names matter. A good name carries enough meaning for a reader to not have to
  dive into the implementation in order to understand the code.
