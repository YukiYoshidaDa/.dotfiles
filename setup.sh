#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_TYPE=$(uname)

echo "--- Starting dotfiles setup ---"
echo "Detected OS: $OS_TYPE"

if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS Setup
    echo "--- 1. Running macOS setup (Homebrew) ---"
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install it first: https://brew.sh/"
        exit 1
    fi
    brew bundle --file "$DOTFILES_DIR/mac/Brewfile"

elif [[ "$OS_TYPE" == "Linux" ]]; then
    # WSL / Linux Setup
    echo "--- 1. Running WSL/Linux setup ---"
    bash "$DOTFILES_DIR/wsl/install_tools.sh"

else
    echo "Unsupported OS type: $OS_TYPE"
    echo "For Windows (Host), please run: ./windows/setup.ps1 in PowerShell as Administrator."
    exit 1
fi

echo "--- 2. Creating symbolic links and installing VS Code extensions ---"
bash "$DOTFILES_DIR/scripts/link.sh"

echo ""
echo "All setup steps completed successfully!"
