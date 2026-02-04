#!/bin/bash
set -e

echo "--- Starting macOS setup (Install Phase) ---"

# 1. Install Homebrew
echo "--- 1. Checking Homebrew ---"
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Configure path for Apple Silicon/Intel
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# 2. Install Tools (Brewfile)
echo "--- 2. Installing Tools via Homebrew ---"
if command -v brew &> /dev/null; then
    # Common Tools
    echo "Installing Common Tools..."
    brew bundle --file="$HOME/.dotfiles/common/Brewfile"

    # Mac Specific Tools
    echo "Installing Mac Specific Tools..."
    brew bundle --file="$HOME/.dotfiles/mac/Brewfile"
else
    echo "Error: Homebrew not found. Aborting."
    exit 1
fi

echo ""
echo "macOS installation complete!"
