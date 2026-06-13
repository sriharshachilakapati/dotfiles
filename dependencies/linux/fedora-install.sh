#!/bin/bash
# Fedora — install dotfile dependencies
# Run: bash fedora-install.sh

set -e

# ── Packages ──────────────────────────────────────────────────────────────────

PACKAGES=(
    # ── Build tools ───────────────────────────────────────────────────────────
    make                    # needed by telescope-fzf-native and Mason
    gcc                     # needed by telescope-fzf-native

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

    # ── Utilities ─────────────────────────────────────────────────────────────
    git
    curl
    wget
    unzip                   # required by Mason (Neovim LSP installer)
    fastfetch
)

echo "==> Installing packages via dnf..."
sudo dnf install -y "${PACKAGES[@]}"

# ── mise (requires COPR) ──────────────────────────────────────────────────────

if command -v mise &>/dev/null; then
    echo "==> mise already installed, skipping."
else
    echo "==> Enabling jdxcode/mise COPR and installing mise..."
    sudo dnf copr enable -y jdxcode/mise
    sudo dnf install -y mise
fi

echo ""
echo "==> Done."
