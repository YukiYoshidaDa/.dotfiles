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

# Git branch info for prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# OS Label
if [[ "$OS_TYPE" == "Darwin" ]]; then
    OS_LABEL="${COLOR_CYAN}[Mac]${COLOR_RESET}"
elif [[ "$IS_WSL" == "true" ]]; then
    OS_LABEL="${COLOR_GREEN}[WSL]${COLOR_RESET}"
else
    OS_LABEL="[Linux]" 
fi

# Main Prompt
setopt PROMPT_SUBST
PROMPT='${OS_LABEL} %# '

# Right Prompt (CWD and Git Branch)
RPROMPT='${COLOR_BLUE}%~${COLOR_RESET} ${COLOR_YELLOW}${vcs_info_msg_0_}${COLOR_RESET}'

# Basic Zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
