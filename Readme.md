# DotFiles

Personal shell, editor, and terminal configuration by Sri Harsha Chilakapati. All configuration is handpicked to match my taste — copy carefully.

## Structure

```
DotFiles/
├── install.sh              # Single entry point — detects platform and runs everything
├── packages/               # Stow-managed dotfile packages (symlinked into $HOME)
│   ├── zsh/                # Zsh config (.zshrc) — Oh-My-Zsh + mise
│   ├── tmux/               # Tmux config (.tmux.conf) — TPM plugins
│   ├── nvim/               # Neovim config (.config/nvim/) — lazy.nvim
│   └── ideavim/            # IdeaVim config (.ideavimrc) — IntelliJ / Android Studio
└── dependencies/           # Platform-specific dependency installers
    ├── macOS/
    │   ├── Brewfile         # Homebrew packages
    │   └── macos-install.sh # Installs Homebrew + runs Brewfile
    └── linux/
        ├── arch-install.sh  # Arch Linux / Manjaro (pacman)
        ├── fedora-install.sh # Fedora (dnf + COPR for mise)
        └── debian-install.sh # Debian / Ubuntu (apt)
```

## Installation

Clone the repository and run the install script:

```sh
git clone https://github.com/sriharsha-chilakapati/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh
```

`install.sh` will:

1. Detect the platform (macOS, Arch, Fedora, Debian/Ubuntu)
2. Install Oh My Zsh
3. Run the appropriate dependency installer
4. Symlink all packages into `$HOME` via GNU Stow
5. Clone TPM and install all Tmux plugins headlessly

Supported platforms: **macOS**, **Arch Linux / Manjaro**, **Fedora**, **Debian / Ubuntu** (and derivatives).

## Packages

### Zsh (`packages/zsh/`)

- **Framework:** Oh-My-Zsh, theme `agnoster`
- **Plugins:** `git`, `gradle`, `zsh-syntax-highlighting`
- **Runtime manager:** `mise` (replaces nvm, rbenv, jenv)
- **Editor:** `nvim` locally, `vim` over SSH

### Tmux (`packages/tmux/`)

- **Prefix:** `Ctrl+A`
- **Plugins via TPM:**
  - `tmux-sensible` — sane defaults
  - `tmux-yank` — copy to system clipboard
  - `tmux-hide-pane` — hide/show a pane
  - `tmux-themepack` — powerline/default/cyan theme
  - `tmux-resurrect` + `tmux-continuum` — session save/restore
- Extended key passthrough enabled (`Shift+Enter`, etc.)

### Neovim (`packages/nvim/`)

- **Plugin manager:** lazy.nvim
- **LSP:** Mason + nvim-lspconfig (TypeScript, Python, Lua, Kotlin, Java, Swift, PureScript)
- **Completion:** nvim-cmp + LuaSnip
- **Fuzzy finder:** Telescope (ripgrep + silver searcher backends)
- **File explorer:** Neo-tree
- **Git:** gitsigns + vim-fugitive
- **Formatting/linting:** none-ls + nvim-lint (prettierd, stylua, ruff, ktlint, swiftformat)

### IdeaVim (`packages/ideavim/`)

- Vim emulation for IntelliJ-family IDEs (IntelliJ IDEA, Android Studio)

### Keybindings

All bindings are kept identical across Neovim, VSCode (via vscode-neovim), and IdeaVim so muscle memory transfers between all three environments. Environment-specific notes are shown where behaviour differs.

**Git**

| Key | Neovim | VSCode | IdeaVim |
|-----|--------|--------|---------|
| `<leader>a` | Git blame | Git blame | `Annotate` |
| `<C-B>` | Git blame (alias) | — | — |

**Code Intelligence**

| Key | Neovim | VSCode | IdeaVim |
|-----|--------|--------|---------|
| `<leader>h` | LSP hover | Show hover | `QuickJavaDoc` |
| `<leader>d` | Diagnostic float | Show hover | `ShowErrorDescription` |
| `<leader>s` | Code action | Quick fix | `ShowIntentionActions` |
| `<leader>ca` | Code action (alias) | Quick fix (alias) | `ShowIntentionActions` (alias) |
| `<leader>rn` | Rename symbol | Rename symbol | `RenameElement` |
| `grn` | Rename symbol (alias) | Rename (alias) | `RenameElement` (alias) |
| `<C-]>` | Go to definition | Reveal definition | `GotoDeclaration` |
| `<C-S-]>` | Show references | Reference search | `FindUsages` |
| `gd` | Go to definition | Reveal definition | `GotoDeclaration` |
| `gD` | Go to declaration | Reveal declaration | `QuickImplementations` (peek popup) |
| `gi` | Go to implementation | Go to implementation | `GotoImplementation` |
| `gt` | Go to type definition | Go to type definition | `GotoTypeDeclaration` |
| `[d` / `]d` | Prev / next diagnostic | Prev / next marker | `GotoPreviousError` / `GotoNextError` |

**Navigation**

| Key | Neovim | VSCode | IdeaVim |
|-----|--------|--------|---------|
| `<C-P>` | Telescope file finder | — | — |
| `<C-S-F>` | Telescope live grep | — | — |
| `<C-n>` | Neo-tree toggle | — | — |
| `<C-J/K/H/L>` | Navigate splits | Navigate splits | Navigate splits |
| `<S-J>` / `<S-K>` | Prev / next buffer | Prev / next tab | Prev / next tab |
| `x` | Kill buffer (keep split) | — | Close tab |

**Editing**

| Key | Neovim | VSCode | IdeaVim |
|-----|--------|--------|---------|
| `<leader>c` | Toggle line comment | Toggle line comment | `CommentByLineComment` |
| `>` / `<` (visual) | Re-indent, keep selection | Re-indent, keep selection | Re-indent, keep selection |
| `,/` | Clear search highlight | — | Clear search highlight |
| `<F2>` | Toggle paste mode | — | — |
| `,r` | Reload config | — | Reload `.ideavimrc` |

## Dependencies

All runtimes (Node, Python, Ruby, Java, etc.) are managed via **mise**. See `mise.toml` or run `mise ls` to view installed versions.
