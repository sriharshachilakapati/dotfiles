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
