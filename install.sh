#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Require GNU stow
if ! command -v stow &>/dev/null; then
    echo "ERROR: 'stow' not found. Install it first:"
    echo "  macOS:  brew install stow"
    echo "  Linux:  apt install stow  /  dnf install stow"
    exit 1
fi

stow --target="$HOME" --dir="$DOTFILES_DIR" --restow zsh tmux ideavim nvim

echo "Dotfiles installed successfully via stow."

# NeoVim treesitter parsers are compiled from source and require the
# tree-sitter CLI binary. Install it before launching nvim:
#   macOS:  brew install tree-sitter-cli
#   Linux:  cargo install tree-sitter-cli
#           -- or -- npm install -g tree-sitter-cli
if ! command -v tree-sitter &>/dev/null; then
    echo "WARNING: 'tree-sitter' CLI not found in PATH."
    echo "         Treesitter parsers will fail to compile on first nvim launch."
    echo "         macOS:  brew install tree-sitter-cli"
    echo "         Linux:  cargo install tree-sitter-cli"
fi
