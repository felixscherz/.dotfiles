---
name: html-communication
description: |-
  Produce a self-contained HTML document for communicating with humans, a write-up, summary, or review doc the user
  reads themselves or sends to other developers. Use when the user mentions "as HTML", "as a document".
  Not for designing frontend UIs or HTML that ships as part of a product.
---

Produce a single self-contained HTML file meant to be read by humans: a
write-up, a summary, a review document. The document is communication, not
product - it will be opened in a browser or forwarded to other developers, never
shipped or deployed.

This skill is strictly for artifacts a human reads. It is not for any artifact
another agent will read.

## Know the audience first

Before writing, be clear about who reads this. The audience shapes everything:
what to assume they already know, which terms to spell out and which to leave
bare, how much context to give, and the voice to use.

- If the audience is stated or can be reasonably inferred from the request,
  proceed with that reading in mind.
- If it cannot be inferred, ask the user who the document is for before writing.
- Match assumed knowledge to that audience. Don't over-explain terms they know,
  and don't assume they share context you happen to have (a repo, a prior
  conversation, an internal tool).

## Run the prose through unslop

This document is prose a human reads, so the writing quality is the product.
Use the `unslop` skill on the text before you consider it done - it strips AI
tells and adds human voice. This is not optional polish; it is part of producing
the document.

## What this is not for

- Artifacts other agents read: specs (`spec.md`), issues, tickets, and any
  markdown an agent consumes downstream. These stay markdown so agents can parse
  them - never emit them as HTML. Specs in particular belong to `to-spec`.
- Designing or prototyping frontend UIs. (The document may _contain_ UI mock
  elements as illustrations, but the document itself is not a UI.)
- Any HTML that ships as part of a product.

## Document style

- Write it like a technical document, not a landing page: dense, scannable, no hero section,
  no fancy UI elements (unless they are part of a UI mock), no marketing voice.
- Default to true black (`#000`) background, white primary text, and dark gray
  only for secondary surfaces or accents.
- Make it mobile readable: responsive viewport meta tag, fluid layout, no
  fixed-width containers.

## Technical constraints

- One file, fully self-contained: semantic HTML, inline CSS, inline SVG, and
  only HTTPS or data-URL images.
- Inline classic `<script>` only when interactivity really matters. Keep the
  document useful with JavaScript disabled.
- External links: in script-free files, give them `target="_blank"` and
  `rel="noopener noreferrer"` so they open in a new tab without handing the
  target page a reference back to this document. If the file contains any
  script, omit `target="_blank"`.
- Never include: external or module scripts, `javascript:` URLs, forms,
  frames, secrets, private URLs, or local filesystem paths.
