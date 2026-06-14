# ── Linux-specific shell configuration ────────────────────────────────────────
# Sourced by ~/.zshrc via ~/.zshrc.d/platform.zsh (symlinked by install.sh).

# mise installs itself to ~/.local/bin on Linux (not /usr/local/bin).
# Prepend it so mise is found before the eval below activates it.
export PATH="$HOME/.local/bin:$PATH"

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/build-tools/"
export PATH="$PATH:$ANDROID_HOME/platform-tools/"
export PATH="$PATH:$ANDROID_HOME/tools/"
