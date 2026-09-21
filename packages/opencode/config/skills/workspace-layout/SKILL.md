---
name: workspace-layout
description: Resolve local repositories, documents, and directories by logical name when another skill refers to workspace-layout or the user asks where workspace resources live. Use also to set up or update a personal or workspace-specific location mapping.
---

# Workspace layout

Resolve logical resource names against the developer's own mapping. Keep personal
locations outside this skill directory. No mapping ships with the skill.

## Select the mapping

Use the session's starting working directory as the lookup anchor. Preserve this
anchor when navigating to another repository so navigation does not change the
active workspace. If the user explicitly switches workspaces, use the new anchor.

Run `scripts/find-workspace.sh <anchor-directory>` from this skill directory.
It prints the selected `WORKSPACE.md` path and exits 0. Exit 1 means no mapping
exists; follow the setup workflow below. Exit 2 means the directory argument is
missing or invalid.

The script selects the nearest `.workspace/WORKSPACE.md` in the anchor directory
or its parents, up to the filesystem root. This allows a workspace containing
several repositories to own their mapping. If none exists, it selects
`~/.config/workspace-layout/WORKSPACE.md` as the personal global default.

A workspace mapping replaces the global mapping in full. Do not merge mappings,
fall back for missing entries, or consult a more distant mapping when the selected
one is empty, unreadable, or invalid. Explain the problem and help repair it.

These are mapping resolution rules, independent of the agent's skill discovery
rules. Do not rely on same-name local skills automatically shadowing global ones.
An explicit mapping path supplied by the user takes precedence over discovery.

## Resolve a resource

Read the selected mapping and match the requested identifier or an explicit alias.
Use descriptions to distinguish candidates, but ask when a name is ambiguous.
If the resource is absent, report it as unmapped in the active mapping. Ask for its
location if needed to continue; do not search the entire machine to guess it.

Resolve relative paths against the directory containing `WORKSPACE.md`, not the
current working directory. Expand a leading `~/` using the developer's home
directory. Treat paths as data, not shell commands or environment expressions.

Check that the target exists and matches its stated kind. If it has moved, ask for
the correct location and update the active mapping when authorized. Do not silently
substitute another clone with the same repository name.

Return the logical identifier, resolved absolute path, and mapping file used.
When another skill invokes this skill, provide that result and resume its workflow.
Read applicable `AGENTS.md` instructions at the destination before working there.
The mapping supplies navigation context, not authorization to modify resources.

## Set up or update

When setup is requested or a mapping is missing:

1. Ask whether the mapping should apply to a particular workspace directory or
   serve as the personal global default. Use an explicitly requested scope without
   asking again. For a workspace, establish its root; do not assume the current
   repository is the whole workspace.
2. Ask for the relevant resource identifiers, locations, and short descriptions.
   Start with the resources needed for the task. Inspect directories the user
   identifies when useful, without treating every discovered repository as an
   intended entry.
3. Validate supplied locations and resolve ambiguous names with the user. If a
   resource is intentionally unavailable, record that explicitly rather than
   inventing a path.
4. Create `<workspace-root>/.workspace/WORKSPACE.md` or the global default
   at `~/.config/workspace-layout/WORKSPACE.md`. Preserve unrelated entries when
   updating an existing file. Store relative paths when useful for workspace
   portability and absolute or home-relative paths for resources elsewhere.
5. Report the mapping location and its scope. Keep personal mappings out of shared
   commits by default. If the mapping is inside a Git repository, use its existing
   local ignore convention or a local Git exclude for `.workspace/`.
   Check whether it is already tracked before claiming it is excluded.

An empty workspace mapping is valid and still shadows the global default. A lookup
that needs a new entry should extend the active mapping, not bypass its scope.

## Mapping format

Use Markdown with a heading for each stable identifier. Record kind, path, and
purpose; aliases are optional. For example, a workspace mapping could contain:

```markdown
# Workspace

## infrastructure
- Kind: repository
- Path: ../infrastructure
- Purpose: Infrastructure definitions and documentation for how services are provisioned and configured
- Aliases: infra

## architecture-notes
- Kind: directory
- Path: ../documents/architecture
- Purpose: Architecture decisions and design discussions

## release-checklist
- Kind: file
- Path: ../documents/release-checklist.md
- Purpose: Steps for preparing a release
```

In this example, `../infrastructure` points to `<workspace-root>/infrastructure` because the mapping
lives in `<workspace-root>/.workspace/`. The examples illustrate the format;
they are not entries to add during setup.

Other skills can reference this contract directly:

> Use workspace-layout to resolve the `infrastructure` repository in the active
> workspace, then inspect it to understand how infrastructure is defined.

Keep project architecture and development procedures in the destination's docs.
The mapping needs only enough context to locate and distinguish resources.
