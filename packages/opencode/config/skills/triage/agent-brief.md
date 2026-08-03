# Writing agent briefs

An agent brief is a structured section in an issue file, written when the issue moves to `ready-for-agent`. It is the authoritative specification a future agent session will work from - possibly days or weeks later, with no memory of the current session. The issue body and notes are context; the agent brief is the contract.

## Principles

### Durability over precision

The codebase will change between writing and pickup. Write the brief so it stays useful even as files are renamed, moved, or refactored.

- **Do** describe interfaces, types, and behavioral contracts
- **Do** name specific types, function signatures, or config shapes the agent should look for or modify
- **Don't** reference file paths - they go stale
- **Don't** reference line numbers
- **Don't** assume the current implementation structure will remain the same

### Behavioral, not procedural

Describe **what** the system should do, not **how** to implement it. The agent will explore the codebase fresh and make its own implementation decisions.

- **Good:** "The `SkillConfig` type should accept an optional `schedule` field"
- **Bad:** "Open src/types/skill.ts and add a schedule field on line 42"
- **Good:** "When the user runs triage with no arguments, they see a summary of issues needing attention"
- **Bad:** "Add a switch statement in the main handler function"

### Complete acceptance criteria

The agent needs to know when it's done. Every brief must have concrete, testable acceptance criteria, each independently verifiable.

- **Good:** "Running X produces Y"
- **Bad:** "X should work correctly"

### Explicit scope boundaries

State what is out of scope. This prevents gold-plating and assumptions about adjacent work.

## Template

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** one-line description of what needs to happen

**Current behavior:**
<What happens now. For bugs, the broken behavior. For enhancements, the status quo the feature builds on.>

**Desired behavior:**
<What should happen after the work is complete. Be specific about edge cases and error conditions.>

**Key interfaces:**
- `TypeName` - what needs to change and why
- `functionName()` return type - what it currently returns vs what it should return
- Config shape - any new options needed

**Acceptance criteria:**
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] Specific, testable criterion 3

**Out of scope:**
- Thing that should NOT be changed or addressed
- Adjacent feature that might seem related but is separate
```

## Example (bug)

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description truncation drops mid-word, producing broken output

**Current behavior:**
When a skill description exceeds 1024 characters, it is truncated at exactly
1024 characters regardless of word boundaries. This produces descriptions
that end mid-word (e.g. "Use when the user wants to confi").

**Desired behavior:**
Truncation breaks at the last word boundary before 1024 characters and
appends "..." to indicate truncation.

**Key interfaces:**
- The validation logic that populates the description from SKILL.md frontmatter

**Acceptance criteria:**
- [ ] Descriptions under 1024 chars are unchanged
- [ ] Descriptions over 1024 chars are truncated at the last word boundary
      before 1024 chars
- [ ] Truncated descriptions end with "..." and never exceed 1024 chars total

**Out of scope:**
- Changing the 1024 char limit itself
- Multi-line description support
```

A bad brief is vague ("fix the triage thing"), references file paths and line numbers that will go stale, and has no acceptance criteria or scope boundaries. If you can't write concrete acceptance criteria yet, the issue is not `ready-for-agent` - grill more or mark it `needs-info`.
