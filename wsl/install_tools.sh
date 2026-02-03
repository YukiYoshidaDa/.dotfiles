#!/bin/bash
set -e

echo "--- Starting WSL setup ---"

# 1. Update system and install basic tools
echo "--- 1. Updating system ---"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git zsh build-essential unzip eza

# Install zsh plugins
echo "--- Installing zsh plugins ---"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# 2. Install fnm (Node.js manager)
echo "--- 2. Installing fnm ---"
if ! command -v fnm &> /dev/null; then
    curl -fsSL https://fnm.vercel.app/install | bash
    # Refresh PATH in current session
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"
    echo "fnm installed and PATH refreshed for this session."
else
    echo "fnm is already installed."
fi

# 3. Install Docker Engine (Native)
echo "--- 3. Installing Docker Engine (Native) ---"
if ! command -v docker &> /dev/null; then
    echo "Using Docker convenience script..."
    curl -fsSL https://get.docker.com | sudo sh

    # Manage Docker as a non-root user
    sudo usermod -aG docker "$(whoami)"
    echo "Docker Engine installed."
    echo "IMPORTANT: To run Docker without sudo, you MUST restart your WSL session or run 'newgrp docker'."
fi

# 4. Final step: Change shell to zsh
echo "--- 4. Changing default shell to zsh ---"
if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s "$(which zsh)" "$(whoami)"
    echo "Default shell changed to zsh. This will take effect on next login."
fi

echo ""
echo "WSL setup complete!"
echo "Next: Run 'bash scripts/link.sh' to apply your dotfiles."
