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

# Mac-specific VSCode settings path
if [[ "$OS_TYPE" == "Darwin" ]]; then
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    files+=(
        "vscode/settings.json:$VSCODE_USER_DIR/settings.json"
        "vscode/keybindings.json:$VSCODE_USER_DIR/keybindings.json"
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

# Install VSCode Extensions
if command -v code &> /dev/null; then
    echo ""
    echo "--- Installing VS Code Extensions ---"
    EXT_FILE="$DOTFILES_DIR/vscode/extensions.txt"
    if [ -f "$EXT_FILE" ]; then
        grep -v '^#' "$EXT_FILE" | grep -v '^$' | while read -r line; do
            echo "Installing extension: $line"
            code --install-extension "$line" --force
        done
    else
        echo "Warning: extensions.txt not found at $EXT_FILE"
    fi
else
    echo ""
    echo "Warning: 'code' command not found. Please ensure VS Code is installed and in your PATH."
fi

echo ""
echo "Setup complete!"
