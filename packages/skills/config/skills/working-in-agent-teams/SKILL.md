---
name: working-in-agent-teams
description: Use when preparing a Saga for delegated execution, planning Episodes for subagents, running an agent team as its Orchestrator, or carrying out an assigned Episode or supporting task as a Worker. Covers one Orchestrator with subagent Workers, role boundaries, handoffs, acceptance, and context management. Not for independent single-agent implementation or peer-to-peer agent choreography.
---

# Working in agent teams

Keep coordination with one agent and detailed task work with its Workers. A large plan can outlive any one context
window, so its decisions and progress belong in durable documents rather than only in conversation history.

## Terminology

| Term | Meaning |
| --- | --- |
| Saga | The entire body of work to distribute, including its goal, plan, constraints, and completion criteria. |
| Episode | A bounded unit of work within a Saga, usually assigned to one Worker. |
| Orchestrator | The single agent that understands the Saga, communicates with the user, tracks the plan, and assigns work. |
| Worker | A subagent assigned an Episode or a supporting task, such as investigation, review, or repository preparation. |

A Worker needs enough context to complete its assignment, not the Orchestrator's entire history. The Saga is not
hidden from Workers; give them access to its plan and include wider context when it affects their decisions.

## Topology

The supported topology is one Orchestrator spawning Workers. Workers report to the Orchestrator; they do not
coordinate their own team or delegate onward. A review or investigation Worker is still a Worker, not another
Orchestrator.

Peer-to-peer teams that choreograph work among themselves are out of scope. Do not silently replace the supported
topology with collaborating peers or nested Orchestrators.

## Workflows and role guides

Identify the current phase and assignment, then read only the relevant guide:

- **Preparation and planning** (`references/planning.md`). Work with the user before execution to define the Saga,
  divide it into Episodes, and prepare documents for a later Saga run.
- **Orchestrator** (`references/orchestrator.md`). Run an approved Saga, assign Workers, track progress, accept results,
  and communicate with the user. Usually this is a separate session from planning.
- **Worker** (`references/worker.md`). Carry out an assigned Episode or supporting task and return its result to the
  Orchestrator.

Loading the skill does not change your assigned role or authorize a Saga run. A planning session remains
pre-execution until the user authorizes execution. A Worker does not become the Orchestrator by reading its guide.

## Shared documents and other skills

Load `agents-folder` for the Saga's shared workspace and follow its placement and handoff rules. Reuse the workspace
given for this Saga, including across checkouts. Keep a canonical plan, Episode briefs, and compact run state there;
reference them instead of maintaining competing copies in prompts.

This skill governs agent coordination, not implementation practices. Load `engineering` and the applicable project
or domain skills when the assignment calls for them. Workers should read their focused references as the work reaches
the relevant phase. Project tooling, branch workflows, and shipping permissions remain with those instructions.
