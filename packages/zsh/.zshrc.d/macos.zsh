# ── macOS-specific shell configuration ────────────────────────────────────────
# Sourced by ~/.zshrc via ~/.zshrc.d/platform.zsh (symlinked by install.sh).

# Homebrew — sets PATH, MANPATH, INFOPATH correctly for both Intel (/usr/local)
# and Apple Silicon (/opt/homebrew) without hardcoding the prefix.
eval "$(brew shellenv)"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/build-tools/"
export PATH="$PATH:$ANDROID_HOME/platform-tools/"
export PATH="$PATH:$ANDROID_HOME/tools/"

# Suppress the Java dock icon for background JVM processes
export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"
