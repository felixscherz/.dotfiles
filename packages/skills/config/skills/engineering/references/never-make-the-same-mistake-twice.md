# Never make the same mistake twice

A codebase should get harder to break with every mistake found in it. When
you find an issue, fix the instance, then ask whether the whole class of error
can be caught automatically in the future.

- Pick the lightest check that catches the class. A type that makes it
  unrepresentable, a unit test, a lint or semgrep rule, or a CI step.
- Look for other instances of the same mistake before adding the check.
- Weigh the ongoing cost - added complexity, slower CI, new tooling - not the
  effort to write the check. Don't add complexity to prevent a small, rare
  error, and propose rather than add a check that needs new CI setup or
  tooling.
- When automated checking is impossible or too costly, record the lesson for
  future agents instead, in the project's `AGENTS.md` or a skill.
