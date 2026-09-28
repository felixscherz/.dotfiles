#!/usr/bin/env bash
set -e
source "$(dirname "$0")/../../lib.sh"

mkdir -p "$HOME/.agents"
# Migrate the link previously owned by the Codex package. Leave other links
# and real directories for Stow to check rather than replacing user content.
skills_link="$HOME/.agents/skills"
if [[ -L "$skills_link" ]]; then
    case "$(readlink "$skills_link")" in
        ../.dotfiles/packages/codex/config/skills|"$DOTFILES_DIR/packages/codex/config/skills")
            rm "$skills_link"
            ;;
    esac
fi
"$(dirname "$0")/link.sh"
