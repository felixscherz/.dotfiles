if [[ $(uname -s) == "Darwin" ]]; then
    export HOMEBREW_NO_ENV_HINTS=TRUE
    export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
    export CC=/opt/homebrew/opt/llvm/bin/clang
fi
