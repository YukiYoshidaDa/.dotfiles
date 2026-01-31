# OS Detection
OS_TYPE=$(uname)
IS_WSL=false
if [[ "$OS_TYPE" == "Linux" ]]; then
    if grep -q "Microsoft" /proc/version 2>/dev/null || grep -q "WSL" /proc/version 2>/dev/null; then
        IS_WSL=true
    fi
fi

# Aliases & Functions based on OS
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # Mac
    alias update='brew update && brew upgrade'
    alias o='open'
elif [[ "$IS_WSL" == "true" ]]; then
    # WSL
    alias update='sudo apt update && sudo apt upgrade'
    alias o='wsl-open'
fi

# Git branch info for prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# Prompt Setup
setopt PROMPT_SUBST

# Colors
COLOR_RESET='%f'
COLOR_CYAN='%F{cyan}'
COLOR_GREEN='%F{green}'
COLOR_YELLOW='%F{yellow}'
COLOR_BLUE='%F{blue}'

# OS Label
if [[ "$OS_TYPE" == "Darwin" ]]; then
    OS_LABEL="${COLOR_CYAN}[Mac]${COLOR_RESET}"
elif [[ "$IS_WSL" == "true" ]]; then
    OS_LABEL="${COLOR_GREEN}[WSL]${COLOR_RESET}"
else
    OS_LABEL="[Linux]" 
fi

# Main Prompt
PROMPT='${OS_LABEL} %# '

# Right Prompt (CWD and Git Branch)
# %~ is current directory
# ${vcs_info_msg_0_} is git branch
RPROMPT='${COLOR_BLUE}%~${COLOR_RESET} ${COLOR_YELLOW}${vcs_info_msg_0_}${COLOR_RESET}'

# Initialize fnm
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# Basic Zsh settings (optional but recommended)
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
