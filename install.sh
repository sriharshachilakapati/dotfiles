#!/bin/bash

install_dotfile() {
    echo "Installing dotfile: $1"

    if [ -f "$HOME/$1" ]; then
        if [ -L "$HOME/$1" ]; then
            echo "Found symlink to dotfile '$HOME/$1'. Removing it"
            rm "$HOME/$1"
        else
            echo "Dotfile '$HOME/$1' is already present. Renaming it to '$HOME/$1.bak'"
            mv "$HOME/$1" "$HOME/$1.bak"
        fi
    fi

    ln -s "$(pwd)/$1" "$HOME/$1"

    echo "Installed dotfile $1"
}

install_dotfile ".zshrc"
install_dotfile ".tmux.conf"
install_dotfile ".vimrc"
install_dotfile ".ideavimrc"

if [ -d "$HOME/.vim/bundle" ]; then
    if [ -L "$HOME/.vim/bundle" ]; then
        echo "Found symlink to bundles directory. Removing it"
        rm "$HOME/.vim/bundle"
    else
        echo "Existing vim bundles found. Renaming them to bundle_old"
        mv "$HOME/.vim/bundle" "$HOME/.vim/bundle_old"
    fi
fi

ln -s "$(pwd)/vimbundles" "$HOME/.vim/bundle"

echo "Installed bundles successfully"

# NeoVim: symlink nvim/ → ~/.config/nvim
if [ -d "$HOME/.config/nvim" ]; then
    if [ -L "$HOME/.config/nvim" ]; then
        echo "Found symlink to ~/.config/nvim. Removing it"
        rm "$HOME/.config/nvim"
    else
        echo "Existing ~/.config/nvim found. Renaming it to ~/.config/nvim.bak"
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    fi
fi

mkdir -p "$HOME/.config"
ln -s "$(pwd)/nvim" "$HOME/.config/nvim"

echo "Installed NeoVim config successfully"

# NeoVim treesitter parsers are compiled from source and require the
# tree-sitter CLI binary. Install it before launching nvim:
#   macOS:  brew install tree-sitter-cli
#   Linux:  cargo install tree-sitter-cli
#           -- or -- npm install -g tree-sitter-cli
if ! command -v tree-sitter &>/dev/null; then
    echo "WARNING: 'tree-sitter' CLI not found in PATH."
    echo "         Treesitter parsers will fail to compile on first nvim launch."
    echo "         macOS:  brew install tree-sitter-cli"
    echo "         Linux:  cargo install tree-sitter-cli"
fi
