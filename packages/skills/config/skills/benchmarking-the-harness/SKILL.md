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

Also strip anything that is not the user's own environment but would leak,
e.g. Claude Code's `synced` skill folder, which carries eval tooling. When
a layer removes a skill, also remove instruction lines that point to it
(e.g. "load the `engineering` skill" in `AGENTS.md`), so the control is the
environment without that skill, not one with a dangling reference.

The harness must read its environment only from the sandbox, never from the
user's home configuration. For opencode see "Running candidates with
opencode" below. Verify it from the trace of a first trial before trusting
the results.

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
5. **Collect.** Per label: the output (sandbox diff and final reply), the
   trace, and the wall time. Time is a cost to report next to the scores.
6. **Verify outcomes yourself.** Before trusting any verdict, check each
   result against the real system: build it, run the binary, reproduce
   against the real dependency. Tests passing is not enough; a candidate's
   unit test can confirm a fix the real tool rejects.
7. **Judge.** Spawn one judge with the rubric, the reference, and all
   redacted traces and outputs by label (see "Redacting traces").
8. **Unblind and analyze.** Apply the key, aggregate scores per variant.
   Check the benchmark's trace expectations against the traces. Compare the
   verdict with your own verification; where they disagree, suspect the
   rubric first. When you change the rubric, archive the old verdict and
   rejudge every trial of that benchmark in one pass.
9. **Report** the finding. Too few trials or a noisy spread is inconclusive,
   not a win.

Before the full arena, run a **pilot** of one trial per variant per
benchmark. It tests the setup, not the variant: isolation holds, the model
resolves, candidates work to the end without stopping, the judge follows the
anchors. A pilot can also surface a real finding about the variant, e.g. a
skill that makes the agent stop and ask where it should work; record it as
a result, not only as a setup problem.

Copy the layers once per arena and reuse them. Adding trials later is fine
as long as layers and constants are unchanged; all trials of a benchmark are
then judged together.

## Redacting traces

- Drop tool calls that touch the environment (skill loads, reads of skill
  or instruction files, commands that name a skill or reference file)
  without leaving a marker: a count of markers reveals the variant.
- Check tool outputs as well as inputs; a directory listing can expose the
  skill tree.
- Rewrite phrases in the candidate's prose that name environment concepts
  (e.g. "checking the feature map").
- Strip the trace expectations section from the rubric the judge gets.
- After rendering, grep every trace for skill names, reference file names
  and environment paths, and fix the renderer on any hit.

Keep the arena record outside every sandbox: manifests, constants, key,
verdict, traces, finding. Ask the user where it lives; benchmarks built from
private code have a private home, and the record goes next to them (e.g.
`<benchmarks>/.arena/<date>-<variable>/`).

## Running candidates with opencode

opencode in headless mode is the default harness: cheap models (e.g.
`github-copilot/gpt-6-luna`) for both candidates and judge, and an
environment that can be pointed at a sandbox. Checked with opencode 2.0.

### Isolation

- **Use a fresh `HOME` per trial.** `OPENCODE_CONFIG_DIR` alone does not
  isolate: `~/.config/opencode` still loads, and skills are discovered
  under `$HOME` (`~/.agents/skills`, `~/.claude/skills`). Set `HOME`,
  `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME` and
  `XDG_CACHE_HOME` into the sandbox, and `OPENCODE_CONFIG_DIR` to
  `<home>/.config/opencode`. Data, db, logs and cache then all live in the
  sandbox, and each trial gets its own session db, so trials share no
  history and stay out of the user's.
- **Always pass `--standalone`.** By default `opencode run` hands the work
  to the background service, which runs with the user's environment and
  ignores the per-trial one. Debug subcommands have no `--standalone` and
  either answer from the service or, under a fresh `HOME`, spawn a new
  service and hang; do not rely on them to check isolation.
- **Keep toolchains working.** A fresh `HOME` hides toolchains installed
  under it. Pass e.g. `CARGO_HOME` and `RUSTUP_HOME` pointing at the real
  ones; Go and uv caches can start empty.
- **Layer contents.** The manifest copies skills to
  `<home>/.agents/skills` and the user's `opencode.json`, `AGENTS.md` and
  `agents/` to `<home>/.config/opencode`, resolving symlinks so later
  edits do not reach a running arena. Add a minimal `<home>/.gitconfig`
  with the user's name and email.
- **Verify** from the sandbox log
  (`<home>/.local/share/opencode/log/opencode.log`): the watched skill
  paths are all under the sandbox, and the first trace shows which skills
  loaded.

### Credentials

- opencode 2 keeps credentials in the `credential` table of
  `opencode.db`, not in `auth.json`; copying `auth.json` does nothing.
- Never copy credentials out of the user's own db. Have the user log in
  once into an arena-only seed directory, with a separate token they can
  revoke:
  `HOME=<seed> XDG_DATA_HOME=<seed>/.local/share XDG_CONFIG_HOME=<seed>/.config opencode auth login`.
  Agents cannot run this; the user runs it (in Claude Code, `! <command>`).
- Start each sandbox from a consistent copy of the seed db, including its
  WAL: `sqlite3 <seed>/.local/share/opencode/opencode.db ".backup '<home>/.local/share/opencode/opencode.db'"`.
- Keep the seed inside the arena record, never in a public repository, and
  never print a credential table or config file with secrets; select
  labels and integration ids only.

### Scripts

`scripts/` implements all of the above. The arena directory holds:

```
<arena>/
  layers/<layer>/{skills,config}  # one directory per variant
  seed/                           # arena-only login (user creates it)
  redact.tsv                      # optional: regex<TAB>replacement for giveaway phrases
  key.tsv                         # label, benchmark, layer, sandbox (coordinator only)
  runs/<label>/                   # events.jsonl, diff.patch, opencode.db, seconds, stderr.log
  verdict-<benchmark>.json
  archive/                        # superseded verdicts
```

- `scripts/global-layer.sh <arena>/layers/<name>` snapshots the user's
  skills and opencode config into a layer, stripping benchmarking skills and
  `synced`. Edit the copy to build a variant (e.g. remove a skill and the
  instruction line pointing to it).
- `scripts/run-arena.sh <arena> <trials> <benchmark-dir>...` runs every
  benchmark x layer x trial in parallel via `scripts/run-trial.sh`. Run it
  again to add trials. `MODEL` overrides the default
  `github-copilot/gpt-6-luna`.
- `scripts/run-judge.sh <arena> <benchmark-dir>` renders redacted traces
  with `scripts/render-trace.py` and judges all trials of the benchmark in
  one pass in an empty environment. `JUDGE_MODEL` overrides the model.
- A benchmark names its sandbox directory in `fixture/repo-name`.

### Running a trial

- `--auto` approves every tool call. A fresh `HOME` does not confine the
  candidate; it can still reach the whole filesystem as the user. Get the
  user's explicit consent before launching `--auto` trials.
- A candidate that asks a question (the `question` tool) or asks for
  confirmation in text ends the trial: nobody answers. Write tasks that
  call for the whole job (see `create-benchmark`), and treat a trial that
  stopped to ask as a result to grade, not a harness failure.
- Put sandboxes under a path a user might pick, e.g.
  `/tmp/agent-runs/<random-hex>/{home,<repo>}`, never under the record.
  Labels and the key stay in the record only. Trials may run in parallel;
  sibling sandboxes are visible to each other, which the judge can flag
  from the traces if it ever matters.
- Before the run, commit the sandbox's starting state into a git dir in
  the record (`git --git-dir=<record>/pre.git --work-tree=<repo> add -A`),
  so the diff afterwards includes untracked files and leaves the sandbox's
  own history untouched.
- Collect per label: `events.jsonl` (the trace), the diff, the sandbox
  `opencode.db`, stderr and wall time.

The judge runs the same way, in an empty environment (no user skills or
instructions), so the user's skills do not shape the grading.

### Quirks

- A startup request can stall for about 5 minutes before the session
  starts; it affects all parallel trials alike and then proceeds. Check the
  sandbox log before assuming a hang.
- A judge can hang at startup with no output; kill it and rerun.
- The exit code says little: a cancelled web search exits 1 after the work
  is done. Judge whether a trial finished from its final reply and diff.
- macOS has no `timeout`; use `perl -e 'alarm 120; exec @ARGV' <command>`.
- Run `man` with `MANPAGER=cat` or not at all; a pager blocks a headless
  shell.

## Benchmark contract

A `benchmark-<slug>` skill contains:

```
benchmark-<slug>/
  SKILL.md         # what the work is, where it came from, how to set it up
  fixture/         # setup.sh and repo-name (sandbox directory name)
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
