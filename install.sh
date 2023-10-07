#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/.dotfiles"
SSH_DIR="$HOME/.ssh"

setup_macos() {
    if ! [ -x "$(command -v brew)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if ! [ -x "$(command -v ansible)" ]; then
        brew install ansible
    fi
}

setup_ubuntu() {
    sudo apt update -y
    if ! [ -x "$(command -v ansible)" ]; then
        sudo apt install ansible -y
    fi
}

case $(uname -s) in
    Darwin) setup_macos;;
    Linux) setup_ubuntu;;
    *) exit 1;;
esac

if ! [[ -f  "$SSH_DIR/id_rsa" ]]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"
    cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

if [[ -f "$DOTFILES_DIR/requirements.yml" ]]; then
    pushd "$DOTFILES_DIR"
    ansible-galaxy install -r requirements.yml
    popd
fi

ansible-playbook --diff "$DOTFILES_DIR/main.yml"
