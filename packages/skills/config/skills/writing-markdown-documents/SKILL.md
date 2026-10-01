---
name: writing-markdown-documents
description: Use whenever writing or editing a markdown file (README, docs, notes, plans, SKILL.md, AGENTS.md, any .md) to keep lines readable in editors without soft wrap. Not for markdown sent only as a chat reply.
---

# Writing markdown documents

Markdown files are often read and edited in a text editor where long lines do not wrap automatically. A paragraph
written as a single 600-character line forces horizontal scrolling and makes diffs hard to review, because changing
one word marks the whole paragraph as changed.

Wrap prose at roughly 120 characters. This is a guideline, not a strict rule:

- Break lines at natural points (between words, ideally after a clause or sentence) once a line nears 120
  characters. A line of 100 or 130 characters is fine.
- Do not break inside inline code, links, or URLs just to stay under the limit. A long URL on its own line is
  better than a broken one.
- Leave code blocks, tables, and headings as they are. Wrapping them changes how they render or makes them harder
  to read.
- Leave YAML frontmatter values on one line. Some tools expect a single-line `description`, for example.
- Continuation lines of a list item are indented to align with the item's text, so the item stays one list entry.
- When editing an existing document, follow its existing wrapping style rather than reflowing untouched paragraphs.
  Reflowing creates noisy diffs.

Rendered output is unaffected: markdown joins consecutive lines of a paragraph into one, so wrapping only helps the
people reading the source.
