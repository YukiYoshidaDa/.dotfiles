# .zshrc Entry Point

# Path to dotfiles (assuming standard location)
export DOTFILES_DIR="$HOME/.dotfiles"

# 1. Load Utilities (OS detection, Prompt, Basics)
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

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

# 5. Initialize Modern Tools

# Homebrew (Linux & Mac)
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Mise (Version Manager - Replaces fnm/asdf)
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Starship
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# FZF
if command -v fzf &> /dev/null; then
    # Try standard locations for keybindings (Brew installs to different locations)
    # Ubuntu/Debian
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

    # Homebrew (Mac/Linux)
    [ -f $(brew --prefix)/opt/fzf/shell/key-bindings.zsh ] && source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
    [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ] && source $(brew --prefix)/opt/fzf/shell/completion.zsh

    # Manual / User
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# fnm
FNM_PATH="/home/ubuntu/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
