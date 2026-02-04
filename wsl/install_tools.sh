#!/bin/bash
set -e

echo "--- Starting WSL setup ---"

# 1. Update system and install basic tools (OS Infrastructure)
echo "--- 1. Updating system (APT) ---"
sudo apt update && sudo apt upgrade -y
# APT: Install only OS essentials and build dependencies
sudo apt install -y curl git zsh build-essential unzip

# Cleanup: Remove tools that should be managed by Homebrew
echo "--- Cleaning up APT packages (migrating to Brew) ---"
sudo apt remove -y bat ripgrep tldr fzf eza || true
sudo apt autoremove -y

# Install zsh plugins (Keep manual install for stability/performance or move to brew later.
# For now, keeping as is per plan to minimize breakage, but could utilize brew).
# Plan says: "zsh ... OS標準". Plugins are grey area but manual clone is fine.
echo "--- Installing zsh plugins ---"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# 2. Install Homebrew
echo "--- 2. Installing Homebrew ---"
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Configure Homebrew path for this session
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# 3. Install Common Dev Tools (via Homebrew)
echo "--- 3. Installing Common Dev Tools (Brewfile) ---"
if command -v brew &> /dev/null; then
    echo "Running brew bundle..."
    # Install gcc from brew if recommended, but we have build-essential.
    brew bundle --file="$HOME/.dotfiles/common/Brewfile"
else
    echo "Error: Homebrew not found. Skipping brew bundle."
fi

# 4. Install Docker (Native - OS Level)
echo "--- 4. Installing Docker Engine (Native) ---"
if ! command -v docker &> /dev/null; then
    echo "Using Docker convenience script..."
    curl -fsSL https://get.docker.com | sudo sh

    # Manage Docker as a non-root user
    sudo usermod -aG docker "$(whoami)"
    echo "Docker Engine installed."
    echo "IMPORTANT: To run Docker without sudo, you MUST restart your WSL session or run 'newgrp docker'."
fi

# 5. Final step: Change shell to zsh
echo "--- 5. Changing default shell to zsh ---"
if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s "$(which zsh)" "$(whoami)"
    echo "Default shell changed to zsh. This will take effect on next login."
fi

echo ""
echo "WSL setup complete!"
echo "Next: Run 'bash scripts/link.sh' to apply your dotfiles."
