#!/bin/bash
# Debian / Ubuntu — install dotfile dependencies
# Run: bash debian-install.sh

set -e

# ── Packages (standard apt repos) ────────────────────────────────────────────

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

    # ── Editor deps (neovim installed separately below) ───────────────────────
    ripgrep                 # telescope.nvim find_files backend  (<C-P>)
    silversearcher-ag       # telescope.nvim live_grep backend   (<C-S-F>)
    fzf                     # telescope-fzf-native + gaf() alias

    # ── Utilities ─────────────────────────────────────────────────────────────
    git
    curl
    wget
    unzip                   # required by Mason (Neovim LSP installer)
)

echo "==> Updating apt and installing packages..."
sudo apt-get update -y
sudo apt-get install -y "${PACKAGES[@]}"

# ── Neovim ────────────────────────────────────────────────────────────────────
# The apt package is severely outdated (0.4–0.6 on most distros).
# Install the latest stable release from the official GitHub tarball instead.

NVIM_BIN="/opt/nvim-linux-x86_64/bin/nvim"

if [ -x "$NVIM_BIN" ]; then
    echo "==> Neovim already installed at $NVIM_BIN, skipping."
else
    echo "==> Installing latest Neovim from GitHub releases..."
    TMP="$(mktemp -d)"
    curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
        -o "$TMP/nvim.tar.gz"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf "$TMP/nvim.tar.gz"
    rm -rf "$TMP"

    # Symlink into a directory already on PATH
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
fi

# ── fastfetch ─────────────────────────────────────────────────────────────────
# Not in standard apt repos on Ubuntu 24.04 / Debian 12 and earlier.
# Install the official .deb from GitHub releases.

if command -v fastfetch &>/dev/null; then
    echo "==> fastfetch already installed, skipping."
else
    echo "==> Installing fastfetch from GitHub releases..."
    TMP="$(mktemp -d)"
    curl -L https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb \
        -o "$TMP/fastfetch.deb"
    sudo dpkg -i "$TMP/fastfetch.deb"
    rm -rf "$TMP"
fi

# ── mise ──────────────────────────────────────────────────────────────────────
# Not in standard apt repos. Use the official installer script.

if command -v mise &>/dev/null; then
    echo "==> mise already installed, skipping."
else
    echo "==> Installing mise..."
    curl https://mise.run | sh
    # mise installs to ~/.local/bin — ensure it's on PATH for the rest of this session
    export PATH="$HOME/.local/bin:$PATH"
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
