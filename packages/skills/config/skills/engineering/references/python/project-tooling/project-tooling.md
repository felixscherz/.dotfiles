# Python project tooling

How to turn the general rules on checks, seams, layout, naming, and fakes into tooling for a Python project. Use it
where the project has no established setup, or to fill a gap in one. The reasoning behind each rule lives in the
general references; this file only says how to enforce it in Python.

## One command verifies a change

- Pin tools in a dev dependency group and commit `uv.lock`. Run every tool through `uv run --locked`, so hooks, local
  runs, and CI use the same versions. Install `just` from PyPI (`rust-just`) to lock it too.
- `uv run --locked just check` is the single entry point for humans, agents, and CI. CI runs `uv sync --locked` and
  that command, nothing else. The README points at it.
- Static checks are defined only in `.pre-commit-config.yaml`, as `repo: local` hooks with `language: system`. The
  justfile runs `pre-commit run --all-files` instead of repeating the commands. Whole-project checks (ty,
  import-linter, deptry, custom scripts) set `pass_filenames: false` and `always_run: true`.
- Tests run in `just test`, never in a pre-commit hook. Keep coverage options out of pytest `addopts` so running one
  test file does not fail the coverage floor. Measure branch coverage and set `fail_under`; the floor only goes up.

```just
check: lint test

lint:
    uv run --locked pre-commit run --all-files

test:
    uv run --locked pytest --cov --cov-report=term-missing:skip-covered
```

## Lint and type rules

Select these Ruff rules on top of the usual `E`, `F`, `I`, `B`, `UP`, `ASYNC`, `ANN`:

| Rule | Why |
| --- | --- |
| `FBT` | No boolean positional arguments; flags are keyword-only |
| `G` (`G004`) | No f-strings in logging calls |
| `LOG015` | No root-logger calls; use `logging.getLogger(__name__)` |
| `TID251` | `banned-api`: side effects go through injected seams (below) |
| `PGH003`, `PGH004` | No blanket `# type: ignore` or `# noqa` |
| `RUF100` | No unused `# noqa` |

Use ty with `--error-on-warning` and `unused-ignore-comment = "error"`. Suppress with `# ty: ignore[<rule>]`, never a
bare ignore. `# pragma: no cover` carries a reason: `# pragma: no cover - process entrypoint`.

## Ban side effects outside adapters

Ruff's `banned-api` rejects direct calls to time, sleeping, randomness, ID generation, environment, and HTTP clients.
Each message names the replacement, so the failure tells the reader what to inject.

```toml
[tool.ruff.lint.flake8-tidy-imports.banned-api]
"datetime.datetime.now".msg = "Use the injected Clock.now()"
"time.sleep".msg = "Use the injected Clock.sleep() so tests don't wait"
"asyncio.sleep".msg = "Use the injected Clock.asleep() so tests don't wait"
"uuid.uuid4".msg = "Inject a new-ID callable; the uuid call belongs in the ID adapter"
"random".msg = "Use the injected RandomSource"
"os.environ".msg = "Add a field to the settings class and pass the value in through the constructor"
"os.getenv".msg = "Add a field to the settings class and pass the value in through the constructor"
"httpx".msg = "Use the injected HttpClient port"

[tool.ruff.lint.per-file-ignores]
"src/<package>/infrastructure/**" = ["TID251"]  # adapters wrap the real APIs
"tests/**" = ["TID251"]  # fixtures may use real values; collaborators still come from fakes
```

- Ban specific call paths where the module's types stay useful (`datetime.datetime.now`, `uuid.uuid4`), so
  `datetime` and `UUID` remain usable in annotations. Ban whole modules (`random`, `httpx`) when the seam does not
  expose their types.
- Settings read the environment through pydantic-settings, so they need no exemption.

## Import contracts

Use import-linter with `include_external_packages = true`, so contracts can forbid frameworks as well as project
packages. Write each contract `name` as the instruction, because it is what the failure prints.

```toml
[[tool.importlinter.contracts]]
name = "Domain depends only on the core"
type = "forbidden"
source_modules = ["service.domain"]
forbidden_modules = ["service.usecases", "service.infrastructure", "service.app", "fastapi", "pydantic"]

[[tool.importlinter.contracts]]
name = "Use cases are independent: share behaviour through a domain service, not by importing another use case"
type = "independence"
modules = ["service.usecases.*"]
ignore_imports = [
    # Workflow errors translated by every entry point; contains no workflow logic
    "service.usecases.* -> service.usecases.errors",
]
```

- Every `ignore_imports` entry carries a comment saying why. A new entry is a design decision; prefer moving the
  shared code to the layer that owns it.
- Keep `allow_indirect_imports` off for core contracts. Turn it on only for adapter contracts where the indirect
  path through the composition root is intended.
- Add every database and network driver to the core's forbidden modules when it is introduced.

## Dependency hygiene

Run `deptry src` as a hook: every imported package is declared, every declared runtime dependency is used, and dev
packages are not imported from `src/`. Every ignore in `[tool.deptry]` carries a comment naming the reason.

## Custom hooks

Small rules that no tool covers become local hooks whose `name` or `entry` is the fix-it message.

```yaml
- id: no-mocks
  name: "Mocks are banned in tests: use a fake from tests/fakes/ that implements the port"
  language: pygrep
  entry: '\b(unittest\.mock|MagicMock|Mock|mocker|pytest_mock)\b'
  files: ^tests/

- id: no-grab-bag-modules
  name: Banned module name
  language: fail
  entry: >-
    Module names utils/helpers/common are banned. Name the module after what it does (e.g. slugs.py, retry.py)
    and place it in the layer that owns the concept.
  files: '(^|/)(utils?|helpers?|common)(\.py|/)'
```

`language: fail` fails for every matching path and prints `entry`. `pygrep` fails on any matching line.

## Fakes

Shared fakes live in `tests/fakes/`, one module per port, and are imported as `tests.fakes`. Set
`pythonpath = ["."]` in `[tool.pytest.ini_options]` and include `tests` in the ty check so ty verifies each fake
against its `Protocol`. A fake needs no inheritance; structural typing is enough. An in-memory production adapter can
serve as the fake instead of a copy. `monkeypatch` is the one patching tool allowed, for environment variables in
settings tests.

## Glossary check

Keep a `GLOSSARY.md` with one `## <Term>` section per concept and optional `- Code:`, `- Avoid:`, and
`- Not to be confused with:` lines. `check_glossary.py` in this folder enforces it: every public class in the concept
modules has a section, and identifiers in the checked layers avoid the listed synonyms. Copy it to `scripts/` and run
it as a hook:

```yaml
- id: glossary
  name: Domain terms match GLOSSARY.md
  entry: >-
    uv run --locked python scripts/check_glossary.py --check 'src/*/domain' --check 'src/*/usecases'
    --concepts 'src/*/domain/**/entities.py' --concepts 'src/*/domain/**/values.py'
  language: system
  pass_filenames: false
  always_run: true
```

Do not check adapter layers: persistence code legitimately talks about rows and records.
