# Program design

Structure a codebase so its parts can be used, and therefore tested, on their
own. Testability is a first-class design goal, not an afterthought. A test is
the first user of an API, and code that is awkward to test is awkward to use.

- Keep a pure core. Domain logic takes values and returns values. Side effects
  (database, HTTP, filesystem, clock) live at the edges.
- Build seams. Dependencies with side effects come in through parameters or
  interfaces, so tests pass in-memory fakes instead of patching. This includes
  the easily overlooked ones: current time, sleeping, randomness, ID
  generation, environment variables, and network calls. Read configuration in
  one place at startup and pass the values in.
- Keep the public surface small and deliberate. Tests target it, so everything
  behind it can change freely.
- When designing an API or model, write the calling code, a test or an
  example, before the implementation.
- Let the layout say where code belongs. Every responsibility should have
  one obvious place, so a reader knows where to find a piece of code and
  where to put a new one. Many layouts achieve this; what matters is that
  the intent is clear and nothing has two plausible homes.
- Make dependency direction executable. When the codebase has layers or
  modules that must not depend on each other, check it with an
  import-contract tool (e.g. import-linter for Python, dependency-cruiser for
  TypeScript, ArchUnit for Java) rather than describing it in prose only.
- Names matter. A good name carries enough meaning for a reader to not have to
  dive into the implementation in order to understand the code. This holds
  for modules too: name a module after what it does (`slugs`, `retry`), never
  `utils`, `helpers`, or `common`, which attract unrelated code and have no
  owner.
