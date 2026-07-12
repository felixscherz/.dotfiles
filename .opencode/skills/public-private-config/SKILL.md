---
name: public-private-config
description: How to split dotfiles config into a public base and a private overlay in this repo - separating company/customer-specific bits (git insteadOf URLs, work email, finicky routing rules, hostnames, tenant IDs) from shareable config. Use when adding a config file that touches company/customer data, deciding what goes public vs private, wiring git/tool include seams, or when config leaked into the public repo. Covers the Go module fetch gotcha with conditional git includes.
---

# Managing public vs private dotfiles config

This repo (`~/.dotfiles`) is public-ish and stow-based. Company/customer-specific
config (internal hostnames, `insteadOf` URLs, work email, customer tenant IDs,
browser-routing rules) must never land in the public packages. This skill defines
the strategy for keeping a shareable public base while overlaying private bits.

## Core principle: seams, not whole-file privatization

Do **not** move an entire config file into the private store just to hide a few
lines. Instead keep a generic **base in the public package** and cut a **seam** -
an include/import point - that an optional private overlay fills in. The public
file stays useful and shareable; only the delta is private.

The private overlay lives in a separate private repo, laid out to mirror the
public package structure and stowed on top (currently `packages/private`, holding
e.g. `git/...`). Prefer a plain sibling clone that `install.sh` optionally stows
over a git submodule: a submodule forces a second commit to bump the pointer in
the public repo on every private change (leaking timing metadata) and adds
detached-HEAD friction, with no real benefit for dotfiles. Keep the submodule only
if one-command `clone --recurse-submodules` bootstrap matters more than that
friction.

## Deciding what goes where

| Concern | Placement | Mechanism |
| --- | --- | --- |
| Generic settings (diff/merge tools, editor, aliases) | Public base | committed normally |
| URL rewrites (`url.*.insteadOf`) for internal hosts | Private overlay | **unconditional** `[include]` |
| Identity (`user.email`, signing key) for work | Private overlay | `[includeIf "gitdir:~/work/"]` is safe here |
| Tool routing full of internal hosts (finicky handlers) | Private overlay | optional import seam, or move whole file private + gitignore |
| Internal hostnames / tenant GUIDs anywhere | Private overlay only | never in a public file |

## The Go module fetch gotcha (important)

Git honors `[include]` directives before doing anything, so an included private
file **is** respected by tools that shell out to git - including `go mod download`.
But **conditional** includes are the trap:

```
[includeIf "gitdir:~/work/"]
    path = ~/.config/git/config.private   # holds the insteadOf rules
```

When Go fetches a module it clones into the **module cache**
(`$GOPATH/pkg/mod/cache/vcs/<hash>`), not into `~/work/`. So `gitdir:~/work/`
never matches, the `insteadOf` rewrite is skipped, and the fetch hits the public
URL and fails. This is why `insteadOf` seemed to require living in the top-level
`.gitconfig`.

**Rule:** scope config by *how* it must apply.

- **URL rewrites (`insteadOf`)** must be **globally / unconditionally** active,
  because Go and any caching tool run outside your work tree. Put them in an
  **unconditional** `[include]`.
- **Identity** may be gated behind `[includeIf "gitdir:~/work/"]`, because you only
  commit from inside real work repos, never from the module cache.

If you ever need conditional URL behavior, git 2.36+ has
`includeIf "hasconfig:remote.*.url:..."` which matches on the remote URL instead
of the directory - but for `insteadOf`, unconditional is simpler and correct.

## Applying the pattern: git

Public `packages/git/config/.config/git/config` (or `~/.gitconfig`) holds all
generic settings and, at the bottom, an unconditional seam:

```
[include]
    path = ~/.config/git/config.private
```

The private overlay ships only `config.private`, containing the `url.*.insteadOf`
rewrites and the work `user.email`. Optionally add an `[includeIf "gitdir:~/work/"]`
block for work identity if it should differ from the default identity.

## Applying the pattern: finicky (and similar mostly-personal tools)

Finicky routing is almost entirely internal hosts, so there is little shareable
base. Two acceptable options:

1. **Import seam** - public `.finicky.js` imports an optional private handlers
   module and concatenates, so the public base carries only generic handlers:
   ```js
   let privateHandlers = [];
   try { privateHandlers = (await import(".../private.js")).default; } catch {}
   export default { defaultBrowser: "Brave Browser",
                    handlers: [...privateHandlers, ...publicHandlers] };
   ```
2. **Whole-file private** - move `.finicky.js` into the private overlay and
   `.gitignore` it in the public repo. Less clever, perfectly fine when there is
   no meaningful public base.

## Safety net: leak-guard pre-commit hook

Structure alone will not stop a slip. This repo already uses pre-commit; add a
local hook that greps staged content in the public repo for a denylist of tokens
(company names, internal domains like `corpintra`, customer tenant GUIDs) and
fails the commit. This is the real backstop and is independent of the layout.

## If a leak already happened

Removing a secret/internal string now only fixes the tip. If the public repo is
published, the data remains in git history. Scrubbing it requires a
force-pushed history rewrite (e.g. `git filter-repo`) - flag this to the user;
it is their call to drive, not something to do silently.

## Related

- `author-skill` - how this file is laid out and why it lives in the opencode
  skills dir.
