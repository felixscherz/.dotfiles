# dotfiles

configuration for the tools I use

## install

Install the configuration by running

```sh
./install.sh
```

which will bootstrap [ansible](https://ansible.com) and install everything.

`./link.sh` only creates the symlinks, without installing software, and
`./unlink.sh` removes them again. Installed software is kept. Both take package
names (`./link.sh nvim zsh`) and default to every package. To move the repo,
run `./unlink.sh`, move it, then run `./link.sh` from the new location.

Install the shared agent skills separately with `./install.sh skills`. Their
source is `packages/skills/config/skills/`, stowed to `~/.agents/skills`.
The installer migrates the previous Codex-owned skills link. OpenCode and
Claude Code keep compatibility links to the same skills.


## building neovim from source

Clone the repo at https://github.com/neovim/neovim and install it to a custom prefix.
```sh
rm -r build/  # clear the CMake cache
rm -r .deps # only sometimes required
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local" CMAKE_BUILD_TYPE=Release
make install
```

## troubleshooting

### spacebar

Regarding accessiblity features abort: https://github.com/koekeishiya/yabai/issues/867#issuecomment-1070721122

Install rosetta `softwareupdate --install-rosetta` to fix Bad CPU Type error.


### Fonts

Install Font Awesome 6 to make Icons work with spacebar
Install Jetbrains Mono Nerd Font to make alacritty work
