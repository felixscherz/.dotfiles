---
name: author-skill
description: How to author, edit, or move an Agent Skill (a SKILL.md) so both opencode and Claude Code discover and read it. Use whenever creating or changing a skill, or when record-learnings decides a learning belongs in a skill. Covers the shared SKILL.md format and the opencode-as-source-of-truth symlink layout.
---

# Authoring skills for opencode and Claude Code

opencode is the primary tool and the source of truth. Claude Code only reads
`~/.claude/*`, so those paths are symlinked into opencode's config. Author skills
so both tools find them.

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
- **Frontmatter:** YAML with only the two fields both tools read:
  - `name`: kebab-case, must match the directory name.
  - `description`: a single line, trigger-rich. Include the phrases a user would
    actually say, so both tools surface the skill at the right moment.
- **Do not add tool-specific frontmatter fields.** Stick to `name` + `description`
  so neither tool chokes on the other's extensions. Put all behavior in the body.
- **Body:** portable markdown (headers, tables, lists). Reference any bundled
  files by relative path.

## Honor the global instructions

The global `AGENTS.md` rules apply to skill content too. In particular:

- Never use the em dash character (U+2014); use a plain dash "-".
- Do not give much weight to development cost when making recommendations.

## After authoring

- The skills dir resolves into the dotfiles git repo, so new or edited skills
  show up as changes there. Remind the user to commit them in `~/.dotfiles`.
- For **project-scoped** skills, use the same `SKILL.md` format inside the
  project. If a project needs both tools to see them, mirror this symlink
  approach for the project's skills directory.

## Related

- `record-learnings` decides *whether* a learning becomes a skill (vs a
  CLAUDE.md/AGENTS.md rule, docs, or memory); this skill governs *how* to write
  the skill once that decision is made.
