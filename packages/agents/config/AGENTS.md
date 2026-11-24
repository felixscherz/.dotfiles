# Agent instructions

These are common instructions for any agent across all scenarios.

## General guidelines

- Never add your own attribution to commits without explicit instruction to do so
- For software engineering work in a codebase, load the `engineering` skill: changing code, and also investigating how
  something works, finding the root cause of a bug or failure, and reviewing code or a pull request
- To change a global skill, edit it in `~/workspaces/personal/skills`, never the installed copies in `~/.agents/skills` or
  `~/.claude/skills`. Load the `author-skill` skill first
