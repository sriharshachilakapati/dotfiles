#!/bin/bash
# Arch Linux / Manjaro — install dotfile dependencies
# Run: bash arch-install.sh

set -e

# ── Packages ──────────────────────────────────────────────────────────────────

PACKAGES=(
    # ── Build tools (includes make, gcc, binutils, etc.) ─────────────────────
    base-devel              # group: needed by telescope-fzf-native and Mason

    # ── Shell ─────────────────────────────────────────────────────────────────
    zsh
    zsh-syntax-highlighting # sourced by Oh-My-Zsh in .zshrc

    # ── Dotfile manager ───────────────────────────────────────────────────────
    stow

    # ── Terminal & multiplexer ────────────────────────────────────────────────
    tmux

    # ── Editor ────────────────────────────────────────────────────────────────
    neovim
    ripgrep                 # telescope.nvim find_files backend  (<C-P>)
    the_silver_searcher     # telescope.nvim live_grep backend   (<C-S-F>)
    fzf                     # telescope-fzf-native + gaf() alias

    # ── Version / runtime manager ─────────────────────────────────────────────
    mise                    # manages node, python, ruby, java, etc.

    # ── Utilities ─────────────────────────────────────────────────────────────
    git
    curl
    wget
    unzip                   # required by Mason (Neovim LSP installer)
    fastfetch
)

echo "==> Installing packages via pacman..."
sudo pacman -S --needed "${PACKAGES[@]}"

# ── zsh-syntax-highlighting OMZ symlink ───────────────────────────────────────
# The package installs to /usr/share/zsh/plugins/; OMZ expects it under custom/plugins/

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_HL_SRC="/usr/share/zsh/plugins/zsh-syntax-highlighting"
ZSH_HL_DEST="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

if [ ! -e "$ZSH_HL_DEST" ]; then
    echo "==> Symlinking zsh-syntax-highlighting into Oh My Zsh custom plugins..."
    ln -s "$ZSH_HL_SRC" "$ZSH_HL_DEST"
fi

echo ""
echo "==> Done."
