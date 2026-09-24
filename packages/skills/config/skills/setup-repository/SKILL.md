---
name: setup-repository
description: Productionize a repository for tagged releases - generated release notes (git-cliff), CI running format/lint/test, prek or pre-commit hooks, LICENSE, and a documented release workflow. Run once per repo. Use when the user says "productionize", "setup repository", "set up releases", "add CI", "prepare for release", or wants release tooling for a repo.
disable-model-invocation: true
---

# Setup repository

Turn a working repository into a releasable one. This skill covers the language-independent pieces; detect the language-specific commands from the repo itself.

Pieces every productionized repo needs:

- **Release notes** generated from commit history, not hand-written
- **CI** running format, lint, and tests on every push and pull request
- **Commit hooks** running format and lint locally (not tests, those belong in CI), ideally the same configuration CI runs so the two cannot drift
- **LICENSE**
- **A documented release workflow**, usually a section in the README

This is a prompt-driven skill, not a deterministic script. Explore, ask, then write.

## Process

### 1. Explore

- Language and toolchain: manifest files (`Cargo.toml`, `package.json`, `pyproject.toml`, `go.mod`), lockfiles. Find the format/lint/test commands: README development section, Makefile or justfile, existing CI.
- Current state: `.github/workflows/` or other CI config, `.pre-commit-config.yaml`, `LICENSE`, `cliff.toml`, existing tags (`git tag -l`), git remote (which hosting platform, or none yet).
- Commit style: `git log --oneline`. Release-note generators parse conventional commits. If the history does not follow them, the commit-msg hook below is mandatory, not optional.

### 2. Ask

One question per decision, recommendation first. Skip questions that exploration already settled.

- **Hosting and CI platform** - GitHub Actions if the remote is github.com or there is no remote yet; otherwise the platform the remote points to.
- **Release flow** - recommend manual tags plus generated notes: the maintainer bumps the version, pushes a tag, CI validates and publishes the release. Alternative: release-please or release-plz bots that open release PRs from conventional commits.
- **Tag scheme** - recommend semver `vX.Y.Z` matching the version in the package manifest.
- **License** - default MIT. Check for signals first: an existing LICENSE file, a license field in the package manifest, other repos by the same owner. If nothing settles it, ask the user.

### 3. Write

**Release notes** - `cliff.toml` at the repo root for git-cliff: conventional commits on, commit parsers grouping by type (Added, Fixed, ...), `tag_pattern` matching the tag scheme. Whatever the mechanism, notes must come from history without hand-writing.

**Commit hooks** - `.pre-commit-config.yaml`, run with prek (preferred, no Python env needed) or pre-commit:

- format check and lint on commit; no tests locally
- a commit-msg hook enforcing conventional commits, so the generated release notes stay useful
- hygiene hooks (trailing whitespace, end-of-file, YAML/TOML syntax)

Install with `prek install`.

**CI** - usually `.github/workflows/ci.yml`:

- a lint job running the format check and linter
- a test job running the suite (matrix over the platforms the project targets)
- toolchain caching

Prefer a CI job that runs `prek run --all-files` (or `pre-commit run --all-files`) so local hooks and CI execute the exact same checks. When that is impractical, keep the commands in both places character-identical.

**Release on tag** (GitHub) - `.github/workflows/release.yml` triggered by `v*` tags: verify the tag matches the manifest version, run the tests, generate notes for the tag with git-cliff, create the GitHub Release (`permissions: contents: write`).

**LICENSE** - write the file for the chosen license with the owner's name and current year; make sure the package manifest's license field agrees.

**README** - add a `## Releasing` section: how to bump the version, the tag command, what pushing the tag triggers. Add `prek install` to the development setup instructions.

Offer only if the user wants them: dependency update automation (dependabot/renovate), toolchain pinning (`rust-toolchain.toml`, `.nvmrc`), security audit jobs, prebuilt release binaries.

Common defaults when the repo documents nothing (prefer the repo's own commands):

| Stack | Format check | Lint | Test |
| ----- | ------------ | ---- | ---- |
| Rust | `cargo fmt --check` | `cargo clippy --all-targets -- -D warnings` | `cargo test` |
| Python | `ruff format --check` | `ruff check` | `pytest` |
| Node | `prettier --check` | `eslint` | `npm test` |
| Go | `gofmt -l .` | `golangci-lint run` | `go test ./...` |

### 4. Verify

- `prek run --all-files` passes
- `git-cliff --unreleased` produces sensible grouped notes (if git-cliff is not installed, install it into a temp dir for the check rather than onto the user's system)
- All workflow and config files parse as YAML

### 5. Done

Tell the user what was created, what still requires them (create the remote, push, push the first tag), and which suggested extras were left out deliberately.
