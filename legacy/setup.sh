#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS_TYPE=$(uname)

echo "--- Starting dotfiles setup ---"
echo "Detected OS: $OS_TYPE"

# 1. Run OS-specific Installation (Install Phase)
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS
    echo "--- 1. Running macOS Installation ---"
    bash "$DOTFILES_DIR/mac/install.sh"

elif [[ "$OS_TYPE" == "Linux" ]]; then
    # WSL / Linux
    echo "--- 1. Running WSL/Linux Installation ---"
    bash "$DOTFILES_DIR/wsl/install.sh"

else
    echo "Unsupported OS type: $OS_TYPE"
    echo "For Windows (Host), please run: ./setup.ps1 in PowerShell as Administrator."
    exit 1
fi

# 2. Run Linker (Link Configs)
echo "--- 2. Creating symbolic links ---"
bash "$DOTFILES_DIR/scripts/link.sh"

# 3. Run VS Code Setup (App Configs)
echo "--- 3. Configuring VS Code ---"
bash "$DOTFILES_DIR/vscode/install_extensions.sh"

echo ""
echo "All setup steps completed successfully!"
