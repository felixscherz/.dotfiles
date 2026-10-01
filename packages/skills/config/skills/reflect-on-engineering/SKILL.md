---
name: reflect-on-engineering
description: User-invoked review of how the engineering skill served a piece of work. Use when the user asks to reflect on engineering, review the engineering skill based on this work, or decide what it should learn from an implementation. Not for applying engineering rules during a task.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Reflect on engineering

The `engineering` skill should describe how the user works today, not how they
worked when a rule was written. This skill turns a finished piece of work into
evidence about which rules helped, which got in the way, and what is missing.

## Scope

Reflect on the most recent completed piece of work unless the user names another
scope, such as a branch, a PR, a transcript, or a set of past sessions. Do not
include the subsequent discussion about editing the skill unless the user asks.
If several completed tasks could be meant, clarify the scope. State the scope
you used at the top of your reply.

## Gather evidence

Read `../engineering/SKILL.md` and the references that affected decisions in
the work. Read other references when needed to verify a suspected conflict or
missing rule. Then walk through the work and note:

- **Rules applied.** Which rules were read, and which decision each one
  changed. A rule that was read but changed nothing is a signal too.
- **User corrections.** Every time the user redirected, rejected, or corrected
  the work. These are the strongest evidence. Ask whether a rule would have
  prevented the correction, or whether a rule caused it.
- **Stated preferences.** Anything the user said about how they want code
  written, tested, reviewed, or discussed that no rule captures.
- **Triggering.** A rule that should have been loaded but was not, or one that
  was loaded without applying. Both point at the "when" text in the index in
  `SKILL.md` or the rule's `description`.
- **Friction.** A rule that was ambiguous, contradicted another rule or the
  codebase, or pushed toward a worse result.

Quote or point to the concrete moment for each note. Do not report a finding
you cannot tie to something that happened in the scope.

## Judge each finding

- **General or local.** The engineering rules apply across codebases. A lesson
  tied to one project belongs in that project's `AGENTS.md` or a local skill.
  Say where it belongs instead. A language- or framework-specific lesson that
  carries across projects belongs in `references/<language>/`.
- **Pattern or one-off.** One session is weak evidence for a new rule. An
  explicit user preference or a repeated correction is strong evidence. Say
  how strong the evidence is.
- **Sharpen, remove, or add.** Prefer sharpening or removing a rule over adding
  one. A rule that never changes a decision is a candidate for removal.
- **Right skill.** Some findings belong in another skill, such as
  `pair-program`, or in the global `AGENTS.md`. Name the
  target.

## Report

For a review-only request, reply with:

1. **Scope** used.
2. **What helped.** Rules that changed a decision for the better, one line
   each.
3. **Proposed changes.** For each: the target file, the change (add, update,
   remove, or retrigger), the proposed wording or a precise summary of it, the
   evidence from the scope, and the evidence strength.
4. **Out of scope**, if relevant. Findings that belong somewhere other than the
   engineering skill, with the suggested destination.

"No changes needed" is a valid result. Do not invent changes to fill the
report. Keep the report proportionate to the evidence. When the user has asked
for an update, apply the requested changes and report what changed and why
instead of stopping at a proposal.

## Apply

Edit when the user explicitly asks for an update or approves specific proposed
changes. For ambiguous requests such as "review this, it may need updates",
propose changes and ask before editing.

- The skill lives in
  `~/workspaces/personal/.dotfiles/packages/skills/config/skills/engineering/`.
  Remind the user to commit changes there.
- One rule per file in `references/`: frontmatter with `name` matching the
  filename and a `description` stating when it applies, an H1 title, a short
  framing paragraph, and a few bullets.
- A rule with supporting files, such as a script, gets its own folder named
  after the rule, holding `<rule>.md` and those files.
- Language- or framework-specific rules go in `references/<language>/`. They
  may be longer and include examples, but must not restate the general rules
  they build on. Keep their examples consistent with the general rules, since
  an agent copies the example before it reads the prose.
- Keep the index in `../engineering/SKILL.md` in sync when adding, renaming,
  or removing a file.
