# Agent instructions

These are common instructions for any agent across all scenarios.

## General guidelines

- Never use the em dash "—". Use plain dash "-" instead
- When making technical decisions, do not give much weight to development cost
- Never add your own attribution to commits without explicit instruction to do so
- For non-trivial code changes, load the `engineering` skill
- To change a global skill, edit it in `~/workspaces/personal/skills`, never the installed copies in `~/.agents/skills` or
  `~/.claude/skills`. Load the `author-skill` skill first
- In markdown files, wrap prose at roughly 120 characters; leave code blocks, tables, headings, frontmatter, and URLs
  unwrapped, and follow an existing file's wrapping rather than reflowing untouched text
