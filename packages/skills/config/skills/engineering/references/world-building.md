---
name: world-building
description: Apply at the start of a task. Understand the model of the problem before diving into the code.
---

# World building

A codebase is a representation of a model, an abstraction of the real world.
The model does not have to mirror reality, it has to serve the problem. Think
in terms of the model first, then the code. Starting deep in the code risks
missing a wrong model, or chasing a local optimization when a global one is
available.

- Before changing code, understand the problem, the domain, and how the parts
  you are about to touch work together.
- While reading code, check whether it still supports the model or has drifted
  from it. Name any drift you find. Changing the model to resolve it is
  covered by `redesign-from-first-principles.md`.
- Code matters because it is how the model exists. When code and model
  disagree, decide which one is wrong before fixing either.
