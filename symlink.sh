# link nvim configs
ln -sf ~/dotFiles/init.vim ~/.config/nvim/init.vim
# link i3 config
if ![[ -d ~.config/i3 ]]; then mkdir -p ~/.config/i3; fi
ln -sf ~/dotFiles/.config/i3/config ~/.config/i3/config
# link tmux config
ln -sf ~/dotFiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotFiles/.tmux.conf.local ~/.tmux.conf.local
# link alacritty
if ![[ -d ~.config/alacritty ]]; then mkdir -p ~/.config/alacritty; fi

