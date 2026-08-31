_cargo_home="${CARGO_HOME:-$HOME/.cargo}"
addToPathFront "$_cargo_home/bin"
[ -f "$_cargo_home/env" ] && source "$_cargo_home/env"
unset _cargo_home
