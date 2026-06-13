#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Platform & distro detection ───────────────────────────────────────────────

detect_platform() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    arch | manjaro)          echo "arch"   ;;
                    fedora)                  echo "fedora" ;;
                    debian | ubuntu)         echo "debian" ;;
                    *)
                        # Catch distros derived from known families
                        case "$ID_LIKE" in
                            *arch*)            echo "arch"   ;;
                            *fedora*)          echo "fedora" ;;
                            *debian* | *ubuntu*) echo "debian" ;;
                            *)
                                echo "unknown"
                                ;;
                        esac
                        ;;
                esac
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

PLATFORM="$(detect_platform)"

echo "==> Detected platform: $PLATFORM"

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Oh My Zsh already installed, skipping."
else
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# ── Install dependencies ──────────────────────────────────────────────────────

case "$PLATFORM" in
    macos)
        bash "$DOTFILES_DIR/dependencies/macOS/macos-install.sh"
        ;;
    arch)
        bash "$DOTFILES_DIR/dependencies/linux/arch-install.sh"
        ;;
    fedora)
        bash "$DOTFILES_DIR/dependencies/linux/fedora-install.sh"
        ;;
    debian)
        bash "$DOTFILES_DIR/dependencies/linux/debian-install.sh"
        ;;
    unknown)
        echo "ERROR: Unsupported platform '$(uname -s)'."
        echo "       Manually install dependencies, then re-run this script."
        echo "       Supported: macOS, Arch Linux / Manjaro, Fedora, Debian / Ubuntu"
        exit 1
        ;;
esac

# ── Stow dotfiles ─────────────────────────────────────────────────────────────

stow --target="$HOME" --dir="$DOTFILES_DIR/packages" --restow zsh tmux ideavim nvim

echo "==> Dotfiles installed successfully via stow."

# ── TPM (Tmux Plugin Manager) ─────────────────────────────────────────────────

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    echo "==> TPM already installed, skipping clone."
else
    echo "==> Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "==> Installing TPM plugins headlessly..."
"$TPM_DIR/scripts/install_plugins.sh"

echo ""
echo "==> All done."
