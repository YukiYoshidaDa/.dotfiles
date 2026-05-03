# OS Detection
OS_TYPE=$(uname)
IS_WSL=false
if [[ "$OS_TYPE" == "Linux" ]]; then
    if grep -q "Microsoft" /proc/version 2>/dev/null || grep -q "WSL" /proc/version 2>/dev/null; then
        IS_WSL=true
    fi
fi

# Colors
COLOR_RESET='%f'
COLOR_CYAN='%F{cyan}'
COLOR_GREEN='%F{green}'
COLOR_YELLOW='%F{yellow}'
COLOR_BLUE='%F{blue}'
COLOR_RED='%F{red}'
COLOR_MAGENTA='%F{magenta}'


# Basic Zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
