# Agent instructions

These are common instructions for any agent across all scenarios.

## General guidelines

- Never add your own attribution to commits without explicit instruction to do so
- For software engineering work in a codebase, load the `engineering` skill: changing code, and also investigating how
  something works, finding the root cause of a bug or failure, and reviewing code or a pull request
- To change a global skill, edit it in `~/workspaces/personal/skills`, never the installed copies in `~/.agents/skills` or
  `~/.claude/skills`. Load the `author-skill` skill first
- When writing a markdown file that gets committed, put each sentence on its own line (semantic line breaks), so a diff
  or review comment maps to one sentence. Not for GitHub/GitLab comments, PR descriptions, or issue bodies, where a
  single newline renders as a line break
