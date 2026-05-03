# --- Aliases ---

# OS specific Open
if [[ "$OS_TYPE" == "Darwin" ]]; then
    alias o='open'
    alias update='brew update && brew upgrade'
elif [[ "$IS_WSL" == "true" ]]; then
    alias o='wsl-open' # Requires wsl-open installed or use explorer.exe
    alias update='sudo apt update && sudo apt upgrade'
fi

# --- List (ls & eza) ---
# Standard ls
alias ll='ls -l'
alias la='ls -la'

# eza (if installed)
if command -v eza &> /dev/null; then
  alias lz='eza --icons'
  alias lzl='eza --icons -l'
  alias lza='eza --icons -la'
  alias lzt='eza --icons --tree --level=2'
fi

# --- Git ---
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- Docker ---
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

# --- Utils ---
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
