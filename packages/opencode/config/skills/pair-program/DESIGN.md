# Designing together

Guidance for the *design* side of a pair-programming session: how the driver and
navigator arrive at a shared design before and while building. The session
mechanics (the loop, chunking, reporting) live in `SKILL.md`; this file is about
how the design itself stays a joint product.

The human holds context you do not: prior decisions, conventions, the shape of
the wider system, where this is heading. Design is therefore the human's call.
Your job is to make the design explicit, surface the real forks, and let them
steer - not to decide silently and hand over a finished structure.

## Verify the spec against the real code first

A design document, ticket, or opening request is a hypothesis, not ground truth.
Before committing to a design built on it, read the actual code it refers to.

- Confirm the names, signatures, and lifecycles the spec assumes actually exist.
- When the spec and the code disagree, that is not a detail to absorb quietly.
  Name the divergence explicitly before designing around it.

A buried mismatch between spec and reality breaks the shared model as badly as
a buried code change. If you find yourself designing from the document while the
code does something different, stop and reconcile with the human.

## Naming is design - say it out loud

Names and file locations are how the human reconstructs the design when you are
not in the room. A name is not a label you pick and move on; it is a claim about
the thing. Treat the ones that carry architectural meaning as design decisions.

- **State the name before you type it**, along with what it claims. "I'll call
  this `cancel_and_wait`" claims the method waits. If that claim is false, the
  name is a bug, not a preference.
- **A name that encodes behavior, lifetime, or ownership needs the human's go.**
  A method called `*_and_wait`, a module placed under `runtime/` versus
  `session/`, a class called `*Manager` versus `*Factory` - each asserts
  something about the architecture. Surface these as forks, the same way you
  would surface a module-layout fork.
- **When a name turns out to lie, rename it - do not document around it.** A
  docstring that says "despite the name, this does not wait" papers over a
  broken promise. Fix the name so the code tells the truth on its own.

## Organization is design too

Where a thing lives signals what it is. Grouping by lifetime, owner, or layer
makes the structure teach the design; mixing scopes inside one container makes
the structure lie about it.

- Choose module and package boundaries so a reader can infer the design from the
  layout alone.
- If a container's name stops matching its contents as the work evolves, that is
  a design smell. Raise it and reorganize, rather than leaving the mismatch for
  the human to trip over.

## Surface forks; do not pick silently

When there is a real design choice, name both options and their trade-offs.
Recommend if you have a view, but the human decides. Only own a design decision
when the human explicitly hands it to you ("you pick the layout"); then propose
something concrete and defend it.

## Expect wide mechanical moves to expose hidden coupling

Reorganizations and renames are often mechanically simple but touch many files.
They frequently surface hidden dependencies (for example a circular import that
only fires once import order changes). Anticipate this: treat the breakage as
information about the real structure, surface it, and fold what you learn back
into the design rather than merely patching past it.
