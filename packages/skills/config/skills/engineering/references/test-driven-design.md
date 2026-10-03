# Test-driven design

Start every feature and bug fix with how you will verify it is done. For a
feature, designing the test is design work: it is the first use of the new
API. Code written test-first tends toward better design because testability
shapes it from the start (see `program-design.md`).

- Before implementing, state how you will verify the feature works or the bug
  is gone.
- Write the test first and run it. Confirm it fails, and fails for the
  intended reason, before writing the fix or feature.
- For a bug, the failing test is the reproduction. Don't fix what you have not
  reproduced.
- When a test would be clunky or cannot cover the behavior, use the closest
  other check. A runnable one-off script, or steps for the user to verify in a
  test environment after deploying. Say which check you used and why.
