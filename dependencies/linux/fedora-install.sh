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

# ── zsh-syntax-highlighting OMZ symlink ───────────────────────────────────────
# The package installs to /usr/share/zsh-syntax-highlighting/; OMZ expects it under custom/plugins/

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_HL_SRC="/usr/share/zsh-syntax-highlighting"
ZSH_HL_DEST="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

if [ ! -e "$ZSH_HL_DEST" ]; then
    echo "==> Symlinking zsh-syntax-highlighting into Oh My Zsh custom plugins..."
    ln -s "$ZSH_HL_SRC" "$ZSH_HL_DEST"
fi

echo ""
echo "==> Done."
