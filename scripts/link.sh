#!/bin/bash

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OS_TYPE=$(uname)

# Files to link: source (relative to $DOTFILES_DIR) target (absolute path)
files=(
    "common/.zshrc:$HOME/.zshrc"
    "common/.gitconfig:$HOME/.gitconfig"
    "common/.gitignore_global:$HOME/.gitignore_global"
)

# VS Code / Antigravity settings path
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS
    files+=(
        "vscode/settings.json:$HOME/Library/Application Support/Code/User/settings.json"
        "vscode/keybindings.json:$HOME/Library/Application Support/Code/User/keybindings.json"
        "vscode/settings.json:$HOME/Library/Application Support/Antigravity/User/settings.json"
        "vscode/keybindings.json:$HOME/Library/Application Support/Antigravity/User/keybindings.json"
    )
else
    # WSL / Linux
    files+=(
        "vscode/settings.json:$HOME/.vscode-server/data/Machine/settings.json"
        "vscode/keybindings.json:$HOME/.vscode-server/data/Machine/keybindings.json"
        "vscode/settings.json:$HOME/.antigravity-server/data/Machine/settings.json"
        "vscode/keybindings.json:$HOME/.antigravity-server/data/Machine/keybindings.json"
    )
fi

echo "--- Starting symbolic link setup ---"

for entry in "${files[@]}"; do
    source_rel="${entry%%:*}"
    target_path="${entry##*:}"
    source_path="$DOTFILES_DIR/$source_rel"

    if [ ! -e "$source_path" ]; then
        echo "Warning: Source file $source_path does not exist. Skipping."
        continue
    fi

    mkdir -p "$(dirname "$target_path")"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        # Check if already linked correctly
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" == "$source_path" ]; then
            echo "Already linked: $target_path"
            continue
        fi

        # Robust Backup with Timestamp
        backup_path="${target_path}.${TIMESTAMP}.bak"
        echo "Backing up existing $(basename "$target_path") to $(basename "$backup_path")"
        mv "$target_path" "$backup_path"
    fi

    ln -s "$source_path" "$target_path"
    echo "Linked $target_path -> $source_path"
done

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
echo "Setup complete!"
