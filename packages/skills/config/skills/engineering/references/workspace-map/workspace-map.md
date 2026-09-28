---
name: workspace-map
description: Apply at the start of a task, when a task needs a repository, document, or directory outside the current working directory, and after a mapped resource is added, moved, or removed.
---

# Workspace map

Work often spans several repositories, and the context a task needs may live
in a sibling repository or a documents folder. A workspace map names those
resources and points to where they live, so an agent can pull in context from
outside the current repository without being told where to look. It lives at
`.felixws/WORKSPACE_MAP.md` in a workspace root, a directory that may hold
several repositories. That directory is personal and globally git-ignored, so
read it by path; search tools that respect `.gitignore` will skip it.

- Find the map with `find-workspace-map.sh <anchor>` next to this file. The
  anchor is the session's starting directory; keep it when moving into another
  repository. The script prints the nearest `.felixws/WORKSPACE_MAP.md` in the
  anchor or its parents and exits 0, exits 1 when none exists, and exits 2 on
  a bad argument. `~/.felixws/WORKSPACE_MAP.md` acts as the personal default
  for anything under the home directory.
- Use only the map the script selects. A nearer map replaces a more distant
  one in full; do not merge them or fall back when an entry is missing. When
  it is missing or invalid, offer to build or repair it with the user.
- Resolve relative paths against the map's workspace root, the parent of
  `.felixws/`, and expand a leading `~/`. Check the target exists and matches
  its kind. When a resource is unmapped or has moved, ask for its location
  instead of searching the machine or substituting another clone.
- Build it together. Ask for the resources the task needs, their identifiers,
  and a short purpose, and let the user decide what belongs. Do not add every
  repository you happen to discover.
- Keep entries to what locates and distinguishes a resource: kind, path,
  purpose, and optional aliases. How a resource works belongs in its own docs,
  and where a feature lives belongs in its `FEATURE_MAP.md`
  (see `../feature-map.md`).
- Read the destination's `AGENTS.md` before working there. The map gives
  navigation context, not permission to change the resource.
- Keep it current. When a task adds, moves, or removes a mapped resource,
  update the map in the same task.

```markdown
## infrastructure

- Kind: repository
- Path: infrastructure
- Purpose: How services are provisioned and configured
- Aliases: infra

## architecture-notes

- Kind: directory
- Path: documents/architecture
- Purpose: Architecture decisions and design discussions
```
