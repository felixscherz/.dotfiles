#!/usr/bin/env bash
cd ~
sudo apt install python3-neovim
mkdir ~/.local/share/nvim/plugged -p
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sf ~/dotFiles/init.vim ~/.config/nvim/init.vim
sudo apt install ctags
python3 -m venv .nvim-python3
~/.nvim-python3/bin/pip install neovim


# for i3
ln -sf ~/dotFiles/.config/i3/config ~/.config/i3/config
