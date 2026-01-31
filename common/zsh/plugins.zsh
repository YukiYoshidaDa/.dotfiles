# --- Zsh Plugins ---

# Define plugin paths
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # Homebrew installed plugins
    BREW_PREFIX=$(brew --prefix)
    PLUGINS_DIR="$BREW_PREFIX/share"
    
    # zsh-autosuggestions
    if [ -f "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    # zsh-syntax-highlighting
    if [ -f "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi

else 
    # WSL / Linux (Manual install to ~/.zsh/plugins)
    PLUGINS_DIR="$HOME/.zsh/plugins"

    # zsh-autosuggestions
    if [ -f "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    # zsh-syntax-highlighting
    if [ -f "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
fi
