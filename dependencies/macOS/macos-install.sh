#!/bin/bash
# macOS — install dotfile dependencies
# Run: bash macos-install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Homebrew ──────────────────────────────────────────────────────────────────

if command -v brew &>/dev/null; then
    echo "==> Homebrew already installed, skipping."
else
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ── Brew bundle ───────────────────────────────────────────────────────────────

echo "==> Installing packages via brew bundle..."
brew bundle --file "$SCRIPT_DIR/Brewfile"

echo ""
echo "==> Done."
