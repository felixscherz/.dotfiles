---
name: show-me
description: Show the user code or changes in a Neovim viewer in a tmux pane next to the agent, set up with the right files, diff base, and a quickfix tour. Use when the user says "show me", "walk me through", "open it in nvim", asks how a change or piece of code works and seeing it in context would help, or wants to review changes. Only when running inside tmux; not for answers that fit in a sentence or two.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Show me

Explaining code in chat means pasting fragments out of context. Instead, open Neovim next to the conversation,
set it up so the code is already in front of the user, and keep the chat for the explanation. The chat says *why*,
the viewer shows *where*.

## Setup

1. Check that `$TMUX` is set. If not, explain in chat as usual and mention that this skill needs tmux.
2. Start the viewer from the repository root:

   ```bash
   scripts/nvim-pane.sh open "$PWD"
   ```

   It splits the agent's tmux window, starts Neovim with the user's own config, and keeps focus in the agent's
   pane. Calling `open` again reuses the running viewer.
3. Tell the user once that the viewer is in the pane to the right.

`scripts/nvim-pane.sh` (paths relative to this skill's directory) is the only way to talk to the viewer:

| Command | Does |
|---|---|
| `open [dir]` | Start or reuse the viewer, print its socket |
| `cmd <ex command>` | Run one Ex command, exit non-zero on error. Prints nothing on success |
| `eval <expression>` | Print the value of a Vimscript expression |
| `lua` | Run Lua read from stdin, print what it passes to `print`, exit non-zero on error (use a heredoc for several steps) |
| `close` | Quit the viewer, refusing if the user has unsaved changes |

## The viewer belongs to the user

Once it is open, the user may move around, open files, or edit in it.

- Start every new topic in a new tab (`cmd tabnew`), so you do not destroy a layout the user is looking at.
- Never edit, write, or reset buffers in the viewer. Code changes go through your normal file tools.
- Leave the viewer open when you are done. Close it only when the user asks.
- Ask Neovim for state (`eval 'expand("%")'`, `lua` with `print(...)`) instead of assuming the user has not
  moved.

## Recipes

### A guided tour through code

For "how does X work": pick the stops a reader needs, in reading order, and load them into the quickfix list with
a short note on each. The user walks the tour at their own pace with `:cnext` / `:cprev`, and the note for each
stop is visible in the quickfix window.

```bash
scripts/nvim-pane.sh lua <<'EOF'
vim.cmd("tabnew")
vim.fn.setqflist({}, " ", {
  title = "Tour: how login works",
  items = {
    { filename = "src/routes/login.py", lnum = 12, text = "1. request enters here" },
    { filename = "src/auth/session.py", lnum = 40, text = "2. session is created and signed" },
  },
})
vim.cmd("copen | wincmd p | cfirst")
EOF
```

In chat, explain each stop by its number, so the user can match the explanation to the quickfix entry. Keep notes
under about 60 characters. The explanation belongs in chat.

When the user says "next" or asks about a specific stop, move there for them (`cmd 'cc 3'`) and explain it.

### Changes against a base

For "show me what changed" or "how does this change work", show the diff inline in the files, not as a patch in
chat. Pick the base from the question: the merge-base with the default branch for a branch, `HEAD` for
uncommitted work, or a specific commit.

Check what the user's config offers and use the first one that exists:

1. `:DiffBase` (from the user's dotfiles, mini.diff with a switchable base). Check with
   `eval 'exists(":DiffBase")'`, which prints `2` if it exists.

   ```bash
   scripts/nvim-pane.sh lua <<'EOF'
   vim.cmd("tabnew")
   vim.cmd("DiffBase main")
   require("custom.diff_base").hunks_to_qflist()
   vim.cmd("copen | wincmd p | cfirst")
   EOF
   ```

   The overlay (deleted lines and word changes inline) is per buffer. Turn it on for each buffer you want to
   show: `lua` with `MiniDiff.toggle_overlay(0)`. After a mini.diff base change, wait about half a second before
   reading hunks or toggling the overlay, because the reference text loads asynchronously.
2. fugitive: `cmd 'Gvdiffsplit main...'` for one file side by side, `cmd 'Git difftool main...'` for every
   changed hunk in the quickfix list.
3. Plain Neovim: open the file, then `cmd 'vertical diffsplit'` on a scratch buffer filled from
   `git show <rev>:<path>`.

### Walking through a change

When the change touches several files, or the user wants to judge it ("walk me through this", "is this PR
ready?"), combine the diff with a tour. Set the base with `:DiffBase`, then replace the raw hunk list with a curated
quickfix list: the stops in the order a reader should see them, each with a numbered note.

- Find the base with `git merge-base HEAD origin/<default>`, or from `git log --first-parent`. The local default
  branch can be stale, and diffing against it pulls in unrelated upstream commits.
- Order the stops for understanding, not by file:
  1. Start with the observable behavior: the test or example that shows what is different now.
  2. Then the entry point where the new code is called.
  3. Then the core logic.
  4. Then the helpers it relies on.
  5. End with the tests, grouped by scenario.
- Take line numbers from `grep -n` on the current files, never from memory or from the diff's hunk headers.

```bash
scripts/nvim-pane.sh lua <<'EOF'
vim.cmd("tabnew")
vim.cmd("DiffBase 130e430f16")
vim.fn.setqflist({}, " ", {
  title = "Tour: conflicting attribute declarations",
  items = {
    { filename = "tests/attributes.md", lnum = 231, text = "1. the old TODOs, now errors" },
    { filename = "src/check.rs", lnum = 368, text = "2. entry point in the class check" },
    { filename = "src/check.rs", lnum = 251, text = "3. main check: per attribute" },
    { filename = "src/helpers.rs", lnum = 29, text = "4. helper extracted for reuse" },
  },
})
vim.cmd("copen | wincmd p | cfirst")
EOF
```

In chat, follow the same numbers: one short paragraph per stop explaining what it does and why. If the user is
deciding something, such as whether a PR is ready, list the findings after the walkthrough and point to stop
numbers and `file:line`, so each finding can be found in the viewer.

### Several views at once

Use splits inside the tab for things that belong side by side, such as a caller and the function it calls:
`cmd 'vsplit path/to/other.lua'`, then `cmd 'normal! 42Gzz'` to place the cursor. Do not open more than two or
three windows. The pane is narrower than a full screen.

## When it goes wrong

- `open` fails: report the error in chat and fall back to explaining with code fragments.
- A `cmd` or `lua` fails: the error message goes to stderr and the exit code is non-zero. Fix the command, do not
  retry it unchanged. Errors suppressed with `:silent!`, such as those from Neovim's own ftplugins, do not count.
- Messages that commands print (`:echo`, plugin notices) are not returned. Use `eval` or `print` in `lua` to read
  state.
- A command waits for input (a prompt, or "Press ENTER"): send `<Esc>` with `nvim --server <socket> --remote-send
  '<Esc>'` and use a non-interactive variant of the command.
