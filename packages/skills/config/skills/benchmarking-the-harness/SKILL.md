---
name: benchmarking-the-harness
description: Framework for testing how a change to an agent's environment (a skill, instruction file, memory, settings) affects its behavior, using blinded controlled experiments. Use when the user wants to benchmark or compare skill variants, run a benchmark-<slug> skill, design an arena, or asks whether a skill change is actually better.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Benchmarking the harness

A skill change affects every future session, so treat it as an experiment:
hold everything constant except the change, hide from the agents that they
are being measured, and judge the outcomes blind.

This skill defines the vocabulary, the method, and the contract that
`benchmark-<slug>` skills fulfil. The benchmarks themselves are captured from
real day-to-day engineering work and live in those skills, not here.

## Primitives

Use these terms when designing, running, and reporting benchmarks.

- **Benchmark** - a piece of real engineering work, captured for reuse:
  fixture, task, rubric. Provided by a `benchmark-<slug>` skill.
- **Collection** - all benchmarks together: the work the environment should
  handle well.
- **Fixture** - the starting state a candidate works in: project files, git
  history, planted context.
- **Task** - the prompt, worded exactly as a user would type it.
- **Rubric** - 3-6 gradeable criteria. Only the judge sees it.
- **Environment** - everything a candidate sees besides the task: skills,
  instruction files (AGENTS.md, CLAUDE.md), memory, settings, tools.
- **Layer** - a named bundle of environment pieces copied into a sandbox,
  e.g. `global` (a snapshot of the user's real skills and instructions) or
  `engineering-v2`.
- **Manifest** - the ordered list of layers that makes up one environment.
  Later layers override earlier ones.
- **Variant** - one manifest under test. The **control** is the baseline
  variant (current version, or nothing). Every arena has a control.
- **Constants** - what is identical for every candidate in an arena:
  harness, model, effort, permission mode, tools. The judge's model is not a
  constant and can be chosen freely.
- **Arena** - one experiment: one benchmark x variants x constants x trials.
- **Trial** - one candidate run of one variant. Run several trials per
  variant, a single run is an anecdote.
- **Sandbox** - the isolated workspace of one trial.
- **Candidate** - the agent executing a trial. It never knows it is in an
  arena.
- **Coordinator** - the agent running the arena, holding the key.
- **Label** - the neutral name of a trial (`run-k3`). The **key** maps
  labels to variants and stays with the coordinator until judging is done.
- **Leak** - any signal that reveals the evaluation, the variant, or other
  trials to a candidate. A leak invalidates the trial.
- **Judge** - an agent that scores all trials against the rubric in one pass,
  from their traces and outputs, seeing labels only.
- **Trace** - a trial's transcript: the ground truth for what the candidate
  did, as opposed to what it claims.
- **Verdict** - the judge's per-trial, per-criterion scores.
- **Finding** - the coordinator's conclusion after unblinding: promote,
  reject, or inconclusive.

## Environments start empty

A sandbox contains nothing the manifest did not put there. If a candidate
should have the user's global setup, the manifest includes a `global` layer
that copies it in. Layers are copied when the arena starts, so later edits to
the source do not change a running or repeated arena.

When copying any layer, always strip `benchmarking-the-harness`,
`create-benchmark`, and every `benchmark-*` skill.

The harness must read its environment only from the sandbox, never from the
user's home configuration. How to achieve that is harness specific and not
settled yet. Verify it from the trace of a first trial before trusting the
results.

## Blinding

Candidates:

- None of these words appear in any path, file, or prompt a candidate sees:
  benchmark, eval, test (as meta), judge, experiment, rubric, score, compare,
  arena, trial, candidate, variant, control.
- Sandbox directories get names a user might choose for a real project.
- The task states the goal, not what is measured. Never ask a candidate to
  list which skills or rules it followed, grade that from the trace.
- Candidates do not know other candidates exist and share no state (memory,
  transcripts, working directories).

Judge:

- May know it is judging, sees trials by label only, never the variant or
  model.
- Traces reveal the environment (loaded skills, instruction files). Redact
  those parts before handing traces to the judge.
- Scores every trial of the arena in a single pass on one scale.

## Running an arena

1. **Frame.** Name the variable under test, the control, the constants, and
   the number of trials per variant. State which result would promote the
   variant. To assess a variant across the collection, run one arena per
   benchmark with the same variants and constants.
2. **Build.** Per trial: create the sandbox, materialize the fixture, apply
   the manifest, assign a label. Record the key.
3. **Check for leaks.** Inspect every sandbox and the task against the
   blinding rules. Fix and rebuild on any hit.
4. **Run.** Launch every trial as a fresh headless harness process in its
   sandbox, with the same constants and the same task. Never use in-session
   subagents as candidates: they inherit the coordinator's context.
5. **Collect.** Per label: the output (sandbox diff and final reply) and the
   trace.
6. **Judge.** Spawn one judge with the rubric, the reference, and all
   redacted traces and outputs by label.
7. **Unblind and analyze.** Apply the key, aggregate scores per variant.
   Check the benchmark's trace expectations against the traces. Read every
   output yourself; if you disagree with the judge, suspect the rubric first.
8. **Report** the finding. Too few trials or a noisy spread is inconclusive,
   not a win.

Keep the arena record outside every sandbox (use the `agents-folder` skill):
manifests, constants, key, verdict, traces, finding.

## Benchmark contract

A `benchmark-<slug>` skill contains:

```
benchmark-<slug>/
  SKILL.md         # what the work is, where it came from, how to set it up
  fixture/         # the starting state, or a setup script that creates it
  task.md          # the prompt as a user would type it
  rubric.md        # criteria for the judge; trace expectations for the coordinator only
  reference.patch  # judge-only: the accepted solution
```

To create a new benchmark, use the `create-benchmark` skill.

`SKILL.md` may name layers the benchmark requires (e.g. `global`). Trace
expectations are observable facts, such as "read the engineering skill before
editing code".

## Report

Variable under test, control, constants, trials per variant, rubric, verdict
per variant, trace observations, your own reading where it differs from the
judge, finding. Across the collection, report per benchmark: a variant that
improves some benchmarks and regresses others is not a plain win.
