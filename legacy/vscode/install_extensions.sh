#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "--- Installing VS Code Extensions ---"

# Install Extensions (VS Code & Antigravity)
for cmd in "code" "agy"; do
    if command -v "$cmd" &> /dev/null; then
        echo ""
        echo "--- Installing extensions for $cmd ---"
        EXT_FILE="$DOTFILES_DIR/vscode/extensions.txt"
        if [ -f "$EXT_FILE" ]; then
            grep -v '^#' "$EXT_FILE" | grep -v '^$' | while read -r line; do
                echo "Installing extension for $cmd: $line"
                "$cmd" --install-extension "$line" --force
            done
        else
            echo "Warning: extensions.txt not found at $EXT_FILE"
        fi
    else
        echo ""
        echo "Warning: '$cmd' command not found. Skipping extension installation for $cmd."
    fi
done

echo ""
echo "VS Code extensions installation complete!"
