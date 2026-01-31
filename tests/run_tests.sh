#!/bin/bash
set -e

echo "=== STARTING DOTFILES TEST ==="

# 1. Run WSL Setup
echo ">>> Running wsl/setup.sh..."
# We might need to mock systemd/docker daemon if the script tries to start them, 
# but setup.sh mainly installs packages.
bash wsl/setup.sh

# 2. Run Link Script
echo ">>> Running scripts/link.sh..."
bash scripts/link.sh

# 3. Verification
echo ">>> Verifying setup..."

# Check zshrc
if [ -L "$HOME/.zshrc" ]; then
    echo "[PASS] .zshrc is linked."
else
    echo "[FAIL] .zshrc is NOT linked."
    exit 1
fi

# Check gitconfig
if git config --global user.email | grep -q "yuki.yoshida.dev@gmail.com"; then
    echo "[PASS] gitconfig matches expected email."
else
    echo "[FAIL] gitconfig email verification failed."
    exit 1
fi

# Check fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"
if command -v fnm &> /dev/null; then
    echo "[PASS] fnm is installed."
else
    echo "[FAIL] fnm is NOT installed."
    exit 1
fi

# Check Docker (client only, daemon won't run in build)
if command -v docker &> /dev/null; then
    echo "[PASS] docker client is installed."
else
    echo "[FAIL] docker client is NOT installed."
    exit 1
fi

echo "=== ALL TESTS PASSED ==="
