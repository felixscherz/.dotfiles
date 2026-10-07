# Test behavior

The best tests are examples of someone using the code. They call the public
API the way a user would and assert what that user would observe. A test full
of mocks and patches is a design signal: the code is tightly coupled and lacks
seams (see `program-design.md`).

- Test through the public API. When a test reaches into internals, ask whether
  it sits at the right level, or whether the behavior is better tested from
  further out, maybe without calling this code directly.
- When moving responsibility between components, verify the behavior through
  the entry point that currently invokes it. A direct test of the replacement
  component does not prove the application uses it. Start from fresh state
  where existing resources could otherwise hide missing initialization.
- Avoid mocks and patches. At a real external boundary (a third-party API, the
  clock), pass in a fake through a seam instead of patching. When no seam
  exists, push back and revisit the design instead of patching around it.
- A fake is a small, working implementation of the same interface as the real
  dependency, such as an in-memory repository or a settable clock. A mock
  asserts which calls happened; a fake lets the test assert on outcomes, so
  the test survives refactoring and fails when behavior breaks. Share fakes
  across tests instead of redefining them per test, and let the type checker
  verify they fit the interface.
- Keep fakes honest. Run one contract test suite per interface against its
  fake and every real implementation, so a fake cannot drift from the
  behavior it stands in for.
- Patching is acceptable only for process-level state that has no seam, such
  as environment variables in tests of configuration loading.
- Name a test after the behavior it checks. A failing test's name alone
  should say which behavior broke.

  ```python
  # Bad
  def test_create() -> None: ...

  # Good
  def test_created_instruction_can_be_found_through_a_query() -> None: ...
  ```
