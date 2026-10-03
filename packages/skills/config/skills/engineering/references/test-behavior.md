# Test behavior

The best tests are examples of someone using the code. They call the public
API the way a user would and assert what that user would observe. A test full
of mocks and patches is a design signal: the code is tightly coupled and lacks
seams (see `program-design.md`).

- Test through the public API. When a test reaches into internals, ask whether
  it sits at the right level, or whether the behavior is better tested from
  further out, maybe without calling this code directly.
- Avoid mocks and patches. At a real external boundary (a third-party API, the
  clock), pass in a fake through a seam instead of patching. When no seam
  exists, push back and revisit the design instead of patching around it.
- Name a test after the behavior it checks. A failing test's name alone
  should say which behavior broke.

  ```python
  # Bad
  def test_create() -> None: ...

  # Good
  def test_created_instruction_can_be_found_through_a_query() -> None: ...
  ```
