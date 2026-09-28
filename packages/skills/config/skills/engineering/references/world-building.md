---
name: world-building
description: Apply at the start of a task and whenever requirements change or are added. Understand the model of the problem before diving into the code.
---

# World building

A codebase is a representation of a model, an abstraction of the real world.
The model does not have to mirror reality, it has to serve the problem. Think
in terms of the model first, then the code. Starting deep in the code risks
missing a wrong model, or chasing a local optimization when a global one is
available.

- Before changing code, understand the problem, the domain, and how the parts
  you are about to touch work together.
- When requirements change or are added, ask what they change in the model
  first, then carry that change into the code.
- While reading code, check whether it still supports the model or has drifted
  from it. Name any drift you find.
- Code matters because it is how the model exists. When code and model
  disagree, decide which one is wrong before fixing either.
