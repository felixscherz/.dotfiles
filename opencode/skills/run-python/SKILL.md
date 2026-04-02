---
name: run-python
description: How to run Python scripts and tools in projects using uv instead of bare python commands
---

## Default rule

Always use `uv run` instead of bare `python`, `python3`, or direct virtualenv invocations. This applies unless the project's `AGENTS.md` or explicit user instructions say otherwise.

## Examples

| Instead of               | Use                        |
|--------------------------|----------------------------|
| `python script.py`       | `uv run script.py`         |
| `python3 script.py`      | `uv run script.py`         |
| `python -m pytest`       | `uv run pytest`            |
| `python -m mypy src/`    | `uv run mypy src/`         |
| `python -m ruff check .` | `uv run ruff check .`      |
| `python -m module`       | `uv run -m module`         |
| `./venv/bin/python`      | `uv run`                   |

## Why

Most projects do not have a virtualenv pre-activated in the shell environment the agent operates in. `uv run` transparently resolves the correct interpreter and dependencies from `pyproject.toml` or `uv.lock` without requiring prior activation.

## Override

Only fall back to bare `python` or `python3` when the project explicitly instructs it, for example via a note in `AGENTS.md` stating that a virtualenv is already active or that a different runner is required.
