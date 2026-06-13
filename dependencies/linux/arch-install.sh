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

echo ""
echo "==> Done."
