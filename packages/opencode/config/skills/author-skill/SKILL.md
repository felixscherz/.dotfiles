---
name: author-skill
description: How to author, edit, or move an Agent Skill (a SKILL.md) for broad agent compatibility. Use whenever creating or changing a skill, or when record-learnings decides a learning belongs in a skill. Covers the shared SKILL.md format, project-local placement conventions, and the global opencode-as-source-of-truth symlink layout.
---

# Authoring portable agent skills

Skills target multiple harnesses - opencode and Claude Code today, possibly
others later. Author them to be broadly compatible: a portable core every
harness reads, plus optional harness-specific extras that others safely ignore.

## Project-local skill location

Use `.agents/skills/<name>/SKILL.md` by default for project-scoped skills. The
`.agents/skills` location is understood by almost all agent harnesses and avoids
making a new project-specific skill belong to a single harness.

Before creating or moving a project-scoped skill, inspect the repository and
preserve its established convention:

- If the repository already has skills under `.opencode/skills`, put project
  skills there.
- If the repository already has skills under `.claude/skills`, put project
  skills there.
- If neither location contains skills, use `.agents/skills`.
- If more than one of these locations already contains skills, follow explicit
  repository instructions or the location used by the skill being edited. Do
  not consolidate or move existing skills unless the user asks.

These rules apply to repository-local skills. The global skills in this
dotfiles setup use the layout below.

## Source of truth and symlink layout

- opencode's global config lives in the dotfiles repo at
  `~/.dotfiles/packages/opencode/config/`, symlinked to `~/.config/opencode/`.
- Claude Code reads `~/.claude/*`. To keep one source of truth, those are
  symlinks into opencode:
  - `~/.claude/CLAUDE.md` -> `~/.config/opencode/AGENTS.md`
  - `~/.claude/skills` -> `~/.config/opencode/skills`
- Therefore: **author every global skill in the opencode skills dir**,
  `~/.config/opencode/skills/<name>/SKILL.md`. Never create a skill only under
  `~/.claude/skills`; that path is a symlink, and the real content belongs in
  opencode/dotfiles so it is version controlled and visible to both tools.

## Compatible SKILL.md format

- **Layout:** one directory per skill, named in kebab-case, containing a
  `SKILL.md`: `<skills-root>/<skill-name>/SKILL.md`.
- **Frontmatter:** YAML. Two fields are the portable core that every harness
  reads - always provide them:
  - `name`: kebab-case, must match the directory name.
  - `description`: despite its name, treat this as a trigger or routing rule,
    not as a conventional summary of the skill's contents. Models see it before
    deciding whether to read the body, so it must explain the concrete
    situations in which the skill should be loaded. Include phrases users would
    actually say, relevant context, and useful boundaries. Sometimes a content
    summary is the wrong description because it says what is inside without
    giving the model enough guidance about when that content applies. Keep it
    to a single line in the YAML.
- **Additional frontmatter fields are allowed** when a harness uses them.
  Harnesses ignore fields they don't know, so extra fields don't break
  compatibility. Keep behavior that matters everywhere in the body; use
  frontmatter fields only for harness-level mechanics. Fields in use:
  - `disable-model-invocation: true` - the skill is user-invocable only, the
    model must not trigger it on its own (read by Claude Code).
  - `argument-hint` - hint shown when the user invokes the skill with arguments.
- **Invocation permissions must match across harnesses.** When a skill is meant
  to be user-invocable only, set `disable-model-invocation: true` in the
  frontmatter AND deny it under `permission.skill` in `opencode.json`. One
  without the other leaves the harnesses behaving differently.
- **Body:** portable markdown (headers, tables, lists). Reference any bundled
  files by relative path.

## Honor the global instructions

The global `AGENTS.md` rules apply to skill content too. In particular:

- Never use the em dash character (U+2014); use a plain dash "-".
- Do not give much weight to development cost when making recommendations.

## After authoring

- Update the skills index at `<skills-root>/README.md` - it documents how the
  skills fit together. Add new skills to it, remove deleted ones.
- The skills dir resolves into the dotfiles git repo, so new or edited skills
  show up as changes there. Remind the user to commit them in `~/.dotfiles`.
- For **project-scoped** skills, use the same `SKILL.md` format and follow the
  project-local location precedence above.

## Related

- `record-learnings` decides *whether* a learning becomes a skill (vs a
  CLAUDE.md/AGENTS.md rule, docs, or memory); this skill governs *how* to write
  the skill once that decision is made.
