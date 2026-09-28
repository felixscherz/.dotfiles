---
name: keep-engineering-up-to-date
description: Apply when one of these engineering rules proves wrong, outdated, or missing during a task, or when the user asks to update, add to, or prune the engineering skill.
---

# Keep engineering up to date

These rules are a living draft, not a finished standard. Be critical of them.
When one gets in the way, leads to a worse result, or misses a situation, say
so. The user decides when the skill changes.

- Never edit this skill unprompted. When a rule needs changing, suggest it at
  the end of your reply: which file, what change, and why. Edit only when the
  user asks.
- Keep it general. These rules apply across many codebases and tasks. A lesson
  tied to one project, framework, or tool belongs in that project's
  `AGENTS.md` or a local skill instead.
- Prefer sharpening or removing a rule over adding a new one.
- Follow the file convention. One rule per file in `references/`: frontmatter
  with `name` matching the filename and a `description` stating when it
  applies, an H1 title, a short framing paragraph, and a few bullets. Keep the
  index in `SKILL.md` in sync when adding, renaming, or removing a file. A
  rule with supporting files, such as a script, gets its own folder named
  after the rule, holding `<rule>.md` and those files.
- The skill lives in `~/.dotfiles/packages/skills/config/skills/engineering/`.
  Remind the user to commit changes there.
