# initiate direnv to source files properly
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi
