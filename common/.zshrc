# .zshrc Entry Point

# Path to dotfiles (assuming standard location)
export DOTFILES_DIR="$HOME/.dotfiles"

# 1. Load Utilities (OS detection, Prompt, Basics)
if [ -f "$DOTFILES_DIR/common/zsh/utils.zsh" ]; then
    source "$DOTFILES_DIR/common/zsh/utils.zsh"
fi

# 3. Load Aliases
if [ -f "$DOTFILES_DIR/common/zsh/aliases.zsh" ]; then
    source "$DOTFILES_DIR/common/zsh/aliases.zsh"
fi

# 4. Load Plugins
if [ -f "$DOTFILES_DIR/common/zsh/plugins.zsh" ]; then
    source "$DOTFILES_DIR/common/zsh/plugins.zsh"
fi

# 5. Initialize fnm (Node.js manager)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi
